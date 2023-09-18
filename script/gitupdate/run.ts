import { TextLineStream } from "../../deno/deno_std/streams/text_line_stream.ts";
import { Semaphore } from "https://deno.land/x/async@v2.0.2/mod.ts";
import { assert, is, Predicate } from "../../deno/unknownutil/mod.ts";

export type Task = {
  repo: string;
  path: string;
  label?: string;
  rev?: string;
};

export const isTask: Predicate<Task> = is.ObjectOf({
  repo: is.String,
  path: is.String,
  label: is.OptionalOf(is.String),
  rev: is.OptionalOf(is.String),
});

export type JobsMessage = {
  type: "jobs";
  jobs: number;
};

export const isJobsMessage: Predicate<JobsMessage> = is.ObjectOf({
  type: (x): x is "jobs" => x === "jobs",
  jobs: is.Number,
});

export type StartMessage = {
  type: "start";
  jobnr: number;
  label: string;
  hash: string;
};

export const isStartMessage: Predicate<StartMessage> = is.ObjectOf({
  type: (x): x is "start" => x === "start",
  jobnr: is.Number,
  label: is.String,
  hash: is.String,
});

export type EndMessage = {
  type: "end";
  jobnr: number;
  hash: string;
  success: boolean;
};

export const isEndMessage: Predicate<EndMessage> = is.ObjectOf({
  type: (x): x is "end" => x === "end",
  jobnr: is.Number,
  hash: is.String,
  success: is.Boolean,
});

export type TextMessage = {
  type: "stdout" | "stderr";
  jobnr: number;
  text: string;
};

export const isTextMessage: Predicate<TextMessage> = is.ObjectOf({
  type: is.OneOf([
    (x): x is "stdout" => x === "stdout",
    (x): x is "stderr" => x === "stderr",
  ]),
  jobnr: is.Number,
  text: is.String,
});

export function newTaskRunner(tasks: Task[], script: string, jobs = 8) {
  const sem = new Semaphore(jobs);
  const jobstat = Array(jobs).fill(false);

  return new ReadableStream({
    start: async (controller) => {
      controller.enqueue(
        {
          type: "jobs",
          jobs,
        } satisfies JobsMessage,
      );
      await Promise.all(tasks.map(async (task) => {
        await sem.lock(async () => {
          const jobnr = jobstat.indexOf(false);
          jobstat[jobnr] = true;

          const oldHash = await new Deno.Command("git", {
            args: ["-C", task.path, "rev-parse", "@{u}"],
          }).output().then((result) => new TextDecoder().decode(result.stdout))
            .catch(() => "");

          controller.enqueue(
            {
              type: "start",
              jobnr,
              label: task.label ?? task.repo,
              hash: oldHash,
            } satisfies StartMessage,
          );

          const job = new Deno.Command(script, {
            args: [task.path, task.repo, task.rev ?? ""],
            stdin: "null",
            stdout: "piped",
            stderr: "piped",
          }).spawn();

          job.stdout.pipeThrough(new TextDecoderStream())
            .pipeThrough(
              new TextLineStream({
                allowCR: true,
              }),
            )
            .pipeTo(
              new WritableStream({
                write(text: string) {
                  controller.enqueue(
                    {
                      type: "stdout",
                      jobnr,
                      text,
                    } satisfies TextMessage,
                  );
                },
              }),
            );

          job.stderr.pipeThrough(new TextDecoderStream())
            .pipeThrough(
              new TextLineStream({
                allowCR: true,
              }),
            )
            .pipeTo(
              new WritableStream({
                write(text: string) {
                  controller.enqueue(
                    {
                      type: "stderr",
                      jobnr,
                      text,
                    } satisfies TextMessage,
                  );
                },
              }),
            );

          const status = await job.status;

          const newHash = await new Deno.Command("git", {
            args: ["-C", task.path, "rev-parse", "origin/HEAD"],
          }).output().then((result) => new TextDecoder().decode(result.stdout))
            .catch(() => "");

          controller.enqueue(
            {
              type: "end",
              jobnr,
              hash: newHash,
              success: status.success,
            } satisfies EndMessage,
          );

          jobstat[jobnr] = false;
        });
      }));
      controller.close();
    },
  });
}

if (import.meta.main) {
  const tasks: unknown = await (new Response(Deno.stdin.readable).json());
  assert(tasks, is.ArrayOf(isTask));
  const taskRunner = newTaskRunner(tasks, Deno.args[0]);
  for await (const output of taskRunner) {
    console.log(output);
  }
}

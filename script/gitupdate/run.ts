import { is, u } from "../../denops/deps/unknownutil.ts";
import { TextLineStream } from "/data/vim/repos/github.com/denoland/deno_std/streams/text_line_stream.ts";

export type Task = {
  repo: string;
  path: string;
  label?: string;
  rev?: string;
};

export const isTask: u.Predicate<Task> = is.ObjectOf({
  repo: is.String,
  path: is.String,
  label: is.OptionalOf(is.String),
  rev: is.OptionalOf(is.String),
});

export type InitializeMessage = {
  type: "initialize";
  jobs: number;
  maxJobs: number;
};

export const isInitializeMessage: u.Predicate<InitializeMessage> = is.ObjectOf({
  type: is.LiteralOf("initialize"),
  jobs: is.Number,
  maxJobs: is.Number,
});

export type DoneMessage = {
  type: "done";
};

export const isDoneMessage: u.Predicate<DoneMessage> = is.ObjectOf({
  type: is.LiteralOf("done"),
});

export type StartMessage = {
  type: "start";
  jobnr: number;
  label: string;
  hash: string;
};

export const isStartMessage: u.Predicate<StartMessage> = is.ObjectOf({
  type: is.LiteralOf("start"),
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

export const isEndMessage: u.Predicate<EndMessage> = is.ObjectOf({
  type: is.LiteralOf("end"),
  jobnr: is.Number,
  hash: is.String,
  success: is.Boolean,
});

export type TextMessage = {
  type: "stdout" | "stderr";
  jobnr: number;
  text: string;
};

export const isTextMessage: u.Predicate<TextMessage> = is.ObjectOf({
  type: is.OneOf([
    is.LiteralOf("stdout"),
    is.LiteralOf("stderr"),
  ]),
  jobnr: is.Number,
  text: is.String,
});

export function newTaskRunner(tasks: Task[], script: string, maxJobs = 8) {
  return new ReadableStream({
    start: async (controller) => {
      controller.enqueue(
        {
          type: "initialize",
          jobs: tasks.length,
          maxJobs,
        } satisfies InitializeMessage,
      );
      let tasknr = 0;
      await Promise.all(Array.from(Array(maxJobs), async (_, jobnr) => {
        while (true) {
          const task = tasks[tasknr++];
          if (task == null) {
            return;
          }
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
        }
      }));
      controller.enqueue(
        {
          type: "done",
        } satisfies DoneMessage,
      );
      controller.close();
    },
  });
}

if (import.meta.main) {
  const tasks: unknown = await (new Response(Deno.stdin.readable).json());
  u.assert(tasks, is.ArrayOf(isTask));
  const taskRunner = newTaskRunner(tasks, Deno.args[0]);
  for await (const output of taskRunner) {
    console.log(output);
  }
}

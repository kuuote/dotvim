import * as stdpath from "../../deno/deno_std/path/mod.ts";
import type { Denops } from "../../deno/denops_std/denops_std/mod.ts";
import { assert, is } from "../../deno/unknownutil/mod.ts";
import {
  isEndMessage,
  isJobsMessage,
  isStartMessage,
  isTask,
  isTextMessage,
  newTaskRunner,
  StartMessage,
} from "./run.ts";

type JobMsg = Omit<StartMessage, "type"> & {
  end: boolean;
  text: string;
};

class Buffer {
  denops: Denops;
  bufnr: number;
  jobs = 0;
  jobmsg: Record<number, JobMsg> = {};
  ends: string[] = [];
  constructor(denops: Denops, bufnr: number) {
    this.denops = denops;
    this.bufnr = bufnr;
  }

  async handle(msg: unknown) {
    if (isJobsMessage(msg)) {
      this.jobs = msg.jobs;
    }
    if (isStartMessage(msg)) {
      this.jobmsg[msg.jobnr] = {
        ...msg,
        end: false,
        text: "",
      };
    }
    if (isEndMessage(msg)) {
      this.jobmsg[msg.jobnr].end = true;
      this.ends.push(this.jobmsg[msg.jobnr].label);
    }
    if (isTextMessage(msg)) {
      this.jobmsg[msg.jobnr].text = msg.text;
    }
    const txt = [...Array(this.jobs)].map((_, i) => {
      const jobmsg = this.jobmsg[i];
      if (jobmsg == null) {
        return "";
      }
      const header = `${jobmsg.label}: `;
      if (jobmsg.end) {
        return header + "done";
      }
      return header + jobmsg.text;
    }).concat(this.ends.toReversed());
    await this.denops.call("setbufline", this.bufnr, 1, txt);
  }
}

export async function main(denops: Denops, args: unknown) {
  assert(
    args,
    is.ObjectOf({
      tasks: is.String,
      task: is.String,
    }),
  );
  await denops.cmd(
    "tabnew | setlocal buftype=nofile bufhidden=hide noswapfile nowrap",
  );
  const bufnr = Number(await denops.call("bufnr"));

  const tasksFile = args.tasks[0] === "/" ? args.tasks : stdpath.resolve(
    stdpath.fromFileUrl(import.meta.url),
    "..",
    args.tasks,
  );
  const tasks: unknown = await Deno.open(tasksFile, { read: true })
    .then(async (h) => await new Response(h.readable).json());
  assert(tasks, is.ArrayOf(isTask));

  const taskScript = args.task[0] === "/" ? args.task : stdpath.resolve(
    stdpath.fromFileUrl(import.meta.url),
    "..",
    args.task,
  );

  const runner = newTaskRunner(tasks, taskScript);
  const buffer = new Buffer(denops, bufnr);
  (async () => {
    for await (const msg of runner) {
      await buffer.handle(msg);
    }
  })();
  await denops.cmd("split");
}

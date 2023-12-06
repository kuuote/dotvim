import { stdpath } from "../../denops/deps/deno_std.ts";
import { autocmd, Denops } from "../../denops/deps/denops_std.ts";
import { is, u } from "../../denops/deps/unknownutil.ts";
import {
  isDoneMessage,
  isEndMessage,
  isJobsMessage,
  isStartMessage,
  isTextMessage,
  newTaskRunner,
  StartMessage,
} from "./run.ts";
import { loadTasks } from "./util.ts";

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
    if (isDoneMessage(msg)) {
      await autocmd.emit(this.denops, "User", "GitUpdatePost", {
        nomodeline: true,
      });
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
    await this.denops.redraw();
  }
}

export async function run(denops: Denops, args: unknown[]) {
  u.assert(
    args,
    is.TupleOf(
      [
        is.ArrayOf(is.String),
        is.String,
      ] as const,
    ),
  );
  const [pathes, task] = args;
  await denops.cmd(
    "tabnew | setlocal buftype=nofile bufhidden=hide noswapfile nowrap",
  );
  const bufnr = Number(await denops.call("bufnr"));

  const tasks = await loadTasks(pathes);

  const taskScript = task[0] === "/" ? task : stdpath.resolve(
    stdpath.fromFileUrl(import.meta.url),
    "..",
    task,
  );

  const runner = newTaskRunner(tasks, taskScript);
  const buffer = new Buffer(denops, bufnr);
  (async () => {
    for await (const msg of runner) {
      await buffer.handle(msg);
    }
  })();
  await autocmd.emit(denops, "User", "GitUpdatePre", {
    nomodeline: true,
  });
}

export function main(denops: Denops) {
  denops.dispatcher = {
    run: (...args: unknown[]) => run(denops, args),
  };
}

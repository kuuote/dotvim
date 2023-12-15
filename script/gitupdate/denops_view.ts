import { stdpath } from "../../denops/deps/deno_std.ts";
import { autocmd, Denops } from "../../denops/deps/denops_std.ts";
import { is, u } from "../../denops/deps/unknownutil.ts";
import {
  isDoneMessage,
  isEndMessage,
  isInitializeMessage,
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

type JobResult = {
  label: string;
  update: boolean;
};

class Buffer {
  denops: Denops;
  bufnr = -1;
  width = -1;
  jobs = 0;
  maxJobs = 0;
  jobmsg: Record<number, JobMsg> = {};
  ends: JobResult[] = [];

  constructor(denops: Denops) {
    this.denops = denops;
  }

  async open() {
    await this.denops.cmd(
      [
        "tabnew",
        "setlocal buftype=nofile bufhidden=wipe noswapfile nowrap",
        "syntax match diffRemoved /^\\[/",
        "syntax match diffRemoved /]$/",
        "syntax match diffAdded /=\\{2,}/",
        "syntax match Constant /.*:/",
        "syntax match Statement /Update:/",
      ].join("|"),
    );
    this.bufnr = Number(await this.denops.call("bufnr"));
    this.width = Number(
      await this.denops.eval("getwininfo(win_getid())[0].width - 2"),
    );
  }

  async handle(msg: unknown) {
    if (isInitializeMessage(msg)) {
      this.jobs = msg.jobs;
      this.maxJobs = msg.maxJobs;
    }
    if (isDoneMessage(msg)) {
      await autocmd.emit(this.denops, "User", "GitUpdatePost", {
        nomodeline: true,
      });
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
      this.ends.push({
        label: this.jobmsg[msg.jobnr].label,
        update: this.jobmsg[msg.jobnr].hash !== msg.hash,
      });
    }
    if (isTextMessage(msg)) {
      this.jobmsg[msg.jobnr].text = msg.text;
    }

    const curJobs = this.ends.length;
    const prog = this.width -
      Math.ceil((this.jobs - curJobs) / this.jobs * this.width);
    const progress = [
      "[" + "=".repeat(prog) + " ".repeat(this.width - prog) + "]",
    ];
    const jobmsgs = [...Array(this.maxJobs)].map((_, i) => {
      const jobmsg = this.jobmsg[i];
      if (jobmsg == null) {
        return "";
      }
      const header = `${jobmsg.label}: `;
      if (jobmsg.end) {
        return header + "done";
      }
      return header + jobmsg.text;
    });
    const results = this.ends
      .toReversed()
      .sort((a, b) => (a.update ? -1 : 0) + (b.update ? 1 : 0))
      .map((r) => (r.update ? "Update: " : "") + r.label);
    this.redraw([
      progress,
      jobmsgs,
      results,
    ].flat());
  }

  doRedraw = false;
  async redraw(text: string[]) {
    if (this.doRedraw) {
      return;
    }
    this.doRedraw = true;
    try {
      await this.denops.call(
        "setbufline",
        this.bufnr,
        1,
        text,
      );
      if (this.denops.meta.host == "vim") {
        this.denops.redraw();
      }
    } finally {
      this.doRedraw = false;
    }
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
  const tasks = await loadTasks(pathes);

  const taskScript = task[0] === "/" ? task : stdpath.resolve(
    stdpath.fromFileUrl(import.meta.url),
    "..",
    task,
  );

  const runner = newTaskRunner(tasks, taskScript);
  const buffer = new Buffer(denops);
  await buffer.open();
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

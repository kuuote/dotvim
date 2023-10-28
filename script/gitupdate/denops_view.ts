import { stdpath } from "../../denops/deps/deno_std.ts";
import { Denops } from "../../denops/deps/denops_std.ts";
import { assert, ensure, is } from "../../denops/deps/unknownutil.ts";
import {
  isDoneMessage,
  isEndMessage,
  isJobsMessage,
  isStartMessage,
  isTask,
  isTextMessage,
  newTaskRunner,
  StartMessage,
  Task,
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
    if (isDoneMessage(msg)) {
      await this.denops.call("luaeval", "vim.notify('all tasks are done.')")
        .catch(async () => {
          await this.denops.cmd("echomsg msg", {
            msg: "all tasks are done.",
          });
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
  }
}

async function loadTasks(denops: Denops, path?: string): Promise<Task[]> {
  if (path == null) {
    const recordPlugins = ensure(
      await denops.eval("g:dpp#_plugins"),
      is.Record,
    );
    const isGitRepo = (repo: unknown): repo is string => {
      if (!is.String(repo)) {
        return false;
      }
      return repo[0] !== "/";
    };
    const tasks = Object.values(recordPlugins)
      .filter(is.ObjectOf({
        name: is.String,
        path: is.String,
        repo: isGitRepo,
        rev: is.OptionalOf(is.String),
      }))
      .map((plugin) => ({
        repo: plugin.repo,
        path: plugin.path,
        label: plugin.name,
        ...plugin.rev ? { rev: plugin.rev } : {},
      }));
    for (const task of tasks) {
      if (!task.repo.includes(":/")) {
        task.repo = "https://github.com/" + task.repo;
      }
    }
    return tasks;
  }
  const tasksFile = path[0] === "/" ? path : stdpath.resolve(
    stdpath.fromFileUrl(import.meta.url),
    "..",
    path,
  );
  return ensure(
    await Deno.open(tasksFile, { read: true })
      .then(async (h) => await new Response(h.readable).json()),
    is.ArrayOf(isTask),
  );
}

export async function main(denops: Denops, args: unknown) {
  assert(
    args,
    is.ObjectOf({
      tasks: is.OptionalOf(is.String),
      task: is.String,
    }),
  );
  await denops.cmd(
    "tabnew | setlocal buftype=nofile bufhidden=hide noswapfile nowrap",
  );
  const bufnr = Number(await denops.call("bufnr"));

  const tasks = await loadTasks(denops, args.tasks);

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

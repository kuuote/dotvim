import { Denops } from "../../denops/@deps/denops_std.ts";
import { is, u } from "../../denops/@deps/unknownutil.ts";
import { Task } from "./run.ts";

// sort keys for JSON.stringify
export function stringifyReplacer(_key: string, value: unknown): unknown {
  if (!is.Record(value)) return value;
  const ret: Record<string, unknown> = {};
  for (const key of Object.keys(value).sort()) {
    ret[key] = value[key];
  }
  return ret;
}

function isRemoteRepo(repo: unknown): repo is string {
  if (!is.String(repo)) {
    return false;
  }
  return repo[0] !== "/";
}

export async function main(denops: Denops) {
  const recordPlugins = u.ensure(
    await denops.eval("g:dpp#_plugins"),
    is.Record,
  );
  const tasks: Task[] = Object.values(recordPlugins)
    .filter(is.ObjectOf({
      name: is.String,
      path: is.String,
      repo: isRemoteRepo,
      rev: is.OptionalOf(is.String),
      // trueとかにするとマッチしなくなるので弾ける
      gitupdate_ignore: is.OptionalOf(is.LiteralOf(false)),
    }))
    .map((plugin) => ({
      repo: plugin.repo,
      path: plugin.path,
      label: plugin.name,
      rev: plugin.rev,
    }))
    .sort((a, b) => a.label.localeCompare(b.label));
  for (const task of tasks) {
    if (!task.repo.includes(":/")) {
      task.repo = "https://github.com/" + task.repo;
    }
  }
  const data = JSON.stringify(tasks, stringifyReplacer, "\t");
  const file = new URL("./tasks.json", import.meta.url).pathname;
  if (data !== await Deno.readTextFile(file).catch(String)) {
    await denops.cmd("echo msg", { msg: "write tasks.json" });
    await Deno.writeTextFile(file, data);
  }
}

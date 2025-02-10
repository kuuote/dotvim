import { loadTasks } from "../util.ts";
import { getSnapshot } from "./libsnapshot.ts";
import { assert, is } from "jsr:@core/unknownutil";
import { type Denops } from "jsr:@denops/std";

export async function run(args: unknown) {
  assert(
    args,
    is.TupleOf(
      [
        is.ArrayOf(is.String),
        is.String,
      ] as const,
    ),
  );
  const [pathes, outFile] = args;
  const tasks = await loadTasks(pathes);
  const snapshots = (await Promise.all(
    tasks.map((task) => getSnapshot(task.path)),
  ))
    .filter(<T>(x: T): x is NonNullable<T> => x != null);
  await Deno.writeTextFile(outFile, JSON.stringify(snapshots, null, "\t"));
}

export function main(denops: Denops) {
  denops.dispatcher = {
    run: (...args: unknown[]) => run(args),
  };
}

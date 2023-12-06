import { getSnapshot } from "./libsnapshot.ts";

type WalkEntry = Deno.DirEntry & {
  path: string;
};

function* walk(initialPath: string): Generator<WalkEntry> {
  const queue = [initialPath];
  for (let cursor = 0; cursor < queue.length; cursor++) {
    const path = queue[cursor];
    const es = [...Deno.readDirSync(path)]
      .sort((a, b) => a.name.localeCompare(b.name));
    for (const e of es) {
      const newPath = path + "/" + e.name;
      yield {
        ...e,
        path: newPath,
      };
      if (e.isDirectory) {
        queue.push(newPath);
      }
    }
  }
}

const repos = [];

for (const e of walk(Deno.args[0])) {
  if (e.path.endsWith("/.git")) {
    const path = e.path.slice(0, -5);
    repos.push(getSnapshot(path));
  }
}
const data = (await Promise.all(repos))
  .filter(<T>(x: T): x is NonNullable<T> => x != null);
await Deno.writeTextFile(Deno.args[1], JSON.stringify(data));

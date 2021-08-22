async function readdirdir(path: string): Promise<string[]> {
  const dirs = [];
  for await (const e of Deno.readDir(path)) {
    if (e.isDirectory) {
      dirs.push(`${path}/${e.name}`);
    }
  }
  return dirs.sort();
}

async function process(remain: string[]) {
  let pos = 0;
  while (pos < remain.length) {
    const dir = remain[pos++];
    console.log(dir);
    try {
      remain.push(...await readdirdir(dir));
    } catch {
      continue;
    }
  }
}

Deno.chdir(Deno.args[0] ?? ".");
const es = Array.from(Deno.readDirSync(".")).filter((e) => e.isDirectory).map(
  (e) => e.name
).sort();
await process(es);

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

Deno.chdir(import.meta.dirname ?? Deno.exit(1));

const dppBase = Deno.makeTempDirSync();
const realDppBase = "/tmp/dpp";
Deno.env.set("DPP_BASE", dppBase);

await Deno.remove("/tmp/inline.vim", { recursive: true }).catch(String);
await Deno.remove(dppBase, { recursive: true }).catch(String);

try {
  await new Deno.Command("vim", { args: ["-u", "vimrc"] }).spawn().status;
} catch {
  // ignore
}
try {
  await new Deno.Command("nvim", { args: ["-u", "vimrc"] }).spawn().status;
} catch {
  // ignore
}

for (const e of walk(dppBase)) {
  if (e.isSymlink) {
    const real = Deno.realPathSync(e.path);
    Deno.removeSync(e.path);
    Deno.symlinkSync(real, e.path);
  }
  if (e.isFile) {
    const data = Deno.readTextFileSync(e.path);
    const dest = data.replaceAll(dppBase, realDppBase);
    if (data != dest) {
      Deno.writeTextFileSync(e.path, dest);
    }
  }
}

new Deno.Command("rsync", {
  args: ["-a", "--delete-before", `${dppBase}/`, `${realDppBase}/`],
}).outputSync();

Deno.removeSync(dppBase, { recursive: true });

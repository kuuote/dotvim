#!/usr/bin/env -S deno run -A

// import "@std/assert"
// import "@std/internal/io"
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

for (const e of walk(".")) {
  if (e.path.endsWith(".ts")) {
    const data = Deno.readTextFileSync(e.path);
    const dest = data.replaceAll(/"@std\/[^"]+"/g, (str) => {
      const raw = str.slice(1, -1);
      const sp = raw.split("/");
      const mod = sp[1].replaceAll(/-/g, "_");
      const sub = sp[2]?.replaceAll(/-/g, "_") ?? "mod";
      const base = `/data/vim/deps/deno_std/${mod}/${sub}`;
      const ts = base + ".ts";
      try {
        Deno.statSync(ts);
        return `"${ts}"`;
      } catch {
        return `"${base}/mod.ts"`;
      }
    });
    if (data != dest) {
      console.log(`process ${e.path}`);
    }
    Deno.writeTextFileSync(e.path, dest);
  }
}

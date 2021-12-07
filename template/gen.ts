import * as TOML from "/data/deno/std/encoding/toml.ts";

// {lang}/pattern/*.toml より pattern.stpl を生成するジェネレーター

type Template = {
  pattern: string;
  template: string;
};

function isTemplate(x: unknown): x is Template {
  // deno-lint-ignore no-explicit-any
  const o = x as any;
  return o?.pattern && o?.template;
}

async function updateTextFile(path: string, data: string) {
  const old = await Deno.readTextFile(path).catch(() => "");
  if (old !== data) {
    console.log(`update ${path}`);
    await Deno.writeTextFile(path, data);
  }
}

async function processDirectory(path: string) {
  const patternDir = `./${path}/pattern`;
  const templates: string[][] = [];
  for (const p of Deno.readDirSync(patternDir)) {
    const t = TOML.parse(
      await Deno.readTextFile(`${patternDir}/${p.name}`).catch(() => ""),
    );
    if (isTemplate(t)) {
      const lines = [t.pattern];
      for (const l of t.template.split("\n")) {
        if (l.length !== 0) {
          lines.push("\t" + l);
        }
      }
      templates.push(lines);
    } else {
      console.log(`${patternDir}/${p.name} is not a valid template`);
    }
  }
  templates.push([""]);
  const data = templates.flat().join("\n");
  await updateTextFile(`./${path}/pattern.stpl`, data);
}

for (const p of Deno.readDirSync(".")) {
  if (p.isDirectory) {
    await processDirectory(p.name).catch((e) => {
      if (e instanceof Deno.errors.NotFound) {
        return;
      }
      console.log(e);
    });
  }
}

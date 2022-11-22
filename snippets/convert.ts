import * as toml from "https://deno.land/std@0.164.0/encoding/toml.ts";
import * as path from "https://deno.land/std@0.164.0/path/mod.ts";

// from https://qiita.com/usoda/items/dbedc06fd4bf38a59c48
// deno-lint-ignore no-explicit-any
export const stringifyReplacer = (_: unknown, v: any) =>
  (!(v instanceof Array || v === null) && typeof v == "object")
    // deno-lint-ignore no-explicit-any
    ? Object.keys(v).sort().reduce((r: any, k) => {
      r[k] = v[k];
      return r;
    }, {})
    : v;

type Snippet = {
  key: string; // スニペット定義のキーになるので重複不可
  // 下の二つは未定義だった場合キーと同じになる
  description?: string;
  prefix?: string;
  body: string;
};

type CodeSnippets = Record<string, {
  description: string;
  prefix: string;
  body: string[];
}>;

// deno-lint-ignore no-explicit-any
function validate(x: any): Snippet[] {
  if (!Array.isArray(x)) {
    throw Error();
  }
  if (!x.every((e) => typeof e?.key === "string")) {
    throw Error();
  }
  return x;
}

const dir = path.dirname(path.fromFileUrl(import.meta.url));
const files = [...Deno.readDirSync(dir)]
  .filter((e) => e.name.endsWith(".toml"))
  .sort((a, b) => a.name.localeCompare(b.name));

for (const f of files) {
  const tomlFile = path.join(dir, f.name);
  const parsed = toml.parse(Deno.readTextFileSync(tomlFile));
  const snippets = validate(parsed.snippet);
  const codeSnippets: CodeSnippets = {};
  for (const s of snippets) {
    if (typeof s.description !== "string") {
      s.description = s.key;
    }
    if (typeof s.prefix !== "string") {
      s.prefix = s.key;
    }
    codeSnippets[s.key] = {
      description: s.description,
      prefix: s.prefix,
      body: s.body.trim().split("\n"),
    };
  }
  const data = JSON.stringify(codeSnippets, stringifyReplacer, "\t");
  const jsonFile = tomlFile.replace(/toml$/, "json");
  if (data !== await Deno.readTextFile(jsonFile).catch(() => "")) {
    Deno.writeTextFileSync(jsonFile, data);
    console.log("update " + f.name.replace(/.toml$/, ""));
  }
}

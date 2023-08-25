import * as YAML from "../../deno/deno_std/yaml/mod.ts";
import * as fn from "../../deno/denops_std/denops_std/function/mod.ts";
import { Denops } from "../../deno/denops_std/denops_std/mod.ts";
import * as opt from "../../deno/denops_std/denops_std/option/mod.ts";
import * as u from "../../deno/unknownutil/mod.ts";
import * as stdpath from "../../deno/deno_std/path/mod.ts";

// from https://qiita.com/usoda/items/dbedc06fd4bf38a59c48
const stringifyReplacer = (_: unknown, v: unknown) =>
  (!(v instanceof Array || v === null) && typeof v == "object")
    ? Object.keys(v).sort().reduce((r, k) => {
      r[k] = (v as Record<string, unknown>)[k];
      return r;
    }, {} as Record<string, unknown>)
    : v;

export async function main(denops: Denops) {
  denops.dispatcher = {
    async blockSort(
      start: unknown,
      end: unknown,
      findRegExpStr: unknown,
      keyRegExpStr: unknown,
    ) {
      u.assert(start, u.isNumber);
      u.assert(end, u.isNumber);
      u.assert(findRegExpStr, u.isString);
      u.assert(keyRegExpStr, u.isString);
      // 複数行に跨るのでdotAllを入れておく
      const findRegExp = new RegExp(findRegExpStr, "s");
      const keyRegExp = new RegExp(keyRegExpStr, "s");
      const lines = await denops.call(
        "getbufline",
        "%",
        start,
        end,
      ) as string[];

      // findRegExpにマッチする物を見出しとして与えられた行をブロックにバラす
      const blocks: string[][] = [];
      let lineStart = 0;
      for (let i = 0; i < lines.length; i++) {
        if (lines[i].match(findRegExp) && lineStart !== i) {
          blocks.push(lines.slice(lineStart, i));
          lineStart = i;
        }
      }
      blocks.push(lines.slice(lineStart, lines.length));

      // 文中のkeyRegExpにマッチする物をキーとしてソートして繋ぎ直す
      const sorted = blocks
        .map((lines) => {
          const text = lines.join("\n");
          return {
            lines,
            key: text.match(keyRegExp)?.[0] ?? text,
          };
        })
        .sort((a, b) => a.key.localeCompare(b.key))
        .flatMap((b) => b.lines);

      await denops.call("setbufline", "%", start, sorted);
    },
    async formatJSON() {
      // => $DOTVIM/ftplugin/json.vim
      const lines = await fn.getline(denops, 1, "$");
      const obj = JSON.parse(lines.join(""));
      const json = JSON.stringify(obj, stringifyReplacer, 2);
      await fn.deletebufline(denops, "%", 1, "$");
      await fn.setbufline(denops, "%", 1, json.split("\n"));
    },
    async load(path: unknown, args?: unknown) {
      u.assert(path, u.isString);
      // NOTE: Import module with fragment so that reload works properly.
      // https://github.com/vim-denops/denops.vim/issues/227
      const mod = await import(
        `${stdpath.toFileUrl(path).href}#${performance.now()}`
      );
      await mod.main(denops, args);
    },
    async jsonYAML() {
      const lines = await fn.getline(denops, 1, "$");
      const obj = JSON.parse(lines.join(""));
      const yaml = YAML.stringify(obj);
      await fn.deletebufline(denops, "%", 1, "$");
      await fn.setbufline(denops, "%", 1, yaml.split("\n"));
      await opt.filetype.setLocal(denops, "yaml");
    },
    async yamlJSON() {
      const lines = await fn.getline(denops, 1, "$");
      const obj = YAML.parse(lines.join("\n")); // YAMLは改行に意味がある
      const json = JSON.stringify(obj, stringifyReplacer, 2);
      await fn.deletebufline(denops, "%", 1, "$");
      await fn.setbufline(denops, "%", 1, json.split("\n"));
      await opt.filetype.setLocal(denops, "json");
    },
  };

  for await (
    const p of Deno.readDir(new URL("./plugin", import.meta.url).pathname)
  ) {
    if (p.isFile) {
      try {
        const m = await import(
          new URL("./plugin/" + p.name, import.meta.url).pathname
        );
        await m.main(denops);
      } catch (e: unknown) {
        console.log(`can't load ${p.name} by`);
        console.log(e);
      }
    }
  }
}

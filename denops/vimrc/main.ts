import { Denops, vars } from "./deps.ts";
import { uu } from "./deps.ts";
import { defineCommand } from "./util.ts";

export async function main(denops: Denops) {
  denops.dispatcher = {
    async blockSort(
      start: unknown,
      end: unknown,
      findRegExpStr: unknown,
      keyRegExpStr: unknown,
    ) {
      uu.assertNumber(start);
      uu.assertNumber(end);
      uu.assertString(findRegExpStr);
      uu.assertString(keyRegExpStr);
      const findRegExp = new RegExp(findRegExpStr);
      const keyRegExp = new RegExp(keyRegExpStr);
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
    async dumpColors() {
      const defs = (await denops.call("execute", "highlight") as string)
        .split(/\n/)
        .filter((d) => d.match(/^\w/) && d.indexOf("cleared") === -1)
        .map((d) => {
          const [name, params] = d.split(/\s*xxx\s*/);
          const links = params.match(/links to (\w+)/);
          if (links != null) {
            return `hi! link ${name} ${links[1]}`;
          }
          return `hi! ${name} ${params}`;
        });
      return defs;
    },
  };

  await denops.cmd(
    `command! Test let hoge = denops#request('${denops.name}', 'dumpColors', [])`,
  );

  await Promise.resolve();
}

import { Denops, vars } from "./deps.ts";
import { uu } from "./deps.ts";

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
      const lines = await denops.call("getbufline", "%", start, end) as string[];

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
  };
  await Promise.resolve();
}

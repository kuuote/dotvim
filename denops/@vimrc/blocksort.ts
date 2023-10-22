import {
  assert,
  is,
} from "/data/vim/repos/github.com/lambdalisue/deno-unknownutil/mod.ts";
import { Denops } from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/mod.ts";

// 例えば↑のimportを整理するにはvip<Esc>後に
// call vimrc#denops#request('blocksort', 'do', [line("'<"), line("'>"), 'import', '"from.*'])

// dpp.vimのTOMLだとこう
// call vimrc#denops#request('blocksort', 'do', [1, line("$"), 'plugins]]', 'repo.*'])

export function main(denops: Denops) {
  denops.dispatcher = {
    async do(
      start: unknown,
      end: unknown,
      findRegExpStr: unknown,
      keyRegExpStr: unknown,
    ) {
      assert(start, is.Number);
      assert(end, is.Number);
      assert(findRegExpStr, is.String);
      assert(keyRegExpStr, is.String);
      const findRegExp = new RegExp(findRegExpStr);
      // 複数行に跨るのでdotAllを入れておく
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
  };
}

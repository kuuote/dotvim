import * as yaml from "../../../deno/deno_std/yaml/mod.ts";
import * as fn from "../../../deno/denops_std/denops_std/function/mod.ts";
import { Denops } from "../../../deno/denops_std/denops_std/mod.ts";

export function main(denops: Denops) {
  denops.dispatcher.formatNvimLspLog = async () => {
    const lines = await fn.getbufline(denops, "%", 1, "$");
    const newLines = (await Promise.all(
      lines.map(async (line) => {
        const idx = line.indexOf("{");
        if (idx == -1) {
          return line;
        }
        const head = line.slice(0, idx);
        const tail = line.slice(idx);
        const obj = await denops.call("luaeval", tail).catch(() => "luaeval error");
        const y = yaml.stringify(obj as Record<string, unknown>, {
          sortKeys: true,
        });
        return head + "\n" + y;
      }),
    ))
      .join("\n")
      .split("\n");
    await denops.cmd("-tabnew | setlocal buftype=nofile bufhidden=hide noswapfile");
    await fn.setline(denops, 1, newLines);
  };
}

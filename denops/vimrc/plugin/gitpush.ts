import * as fn from "../../../deno/denops_std/denops_std/function/mod.ts";
import { Denops } from "../../../deno/denops_std/denops_std/mod.ts";
import * as util from "../util.ts";

export async function main(denops: Denops) {
  denops.dispatcher.gitPush = async () => {
    let path = await denops.eval(
      "resolve(expand(isdirectory(expand('%:p')) ? '%:p' : '%:p:h'))",
    ) as string;
    if (await Deno.stat(path).then((i) => !i.isDirectory).catch(() => true)) {
      path = await fn.getcwd(denops);
    }
    const p = Deno.run({
      cmd: ["git", "push"],
      cwd: path,
    });
    const s = await p.status();
    await util.notify(denops, "gitPush: " + s.code);
  };

  await denops.cmd(
    `command! GitPush call denops#notify('${denops.name}', 'gitPush', [])`,
  );
}

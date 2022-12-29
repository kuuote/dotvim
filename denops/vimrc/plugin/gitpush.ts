import { Denops } from "../deps.ts";
import * as util from "../util.ts";

export async function main(denops: Denops) {
  denops.dispatcher.gitPush = async () => {
    const path = await denops.eval(
      "resolve(expand(isdirectory(expand('%:p')) ? '%:p' : '%:p:h'))",
    ) as string;
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

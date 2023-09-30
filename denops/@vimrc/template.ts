import { Denops } from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/mod.ts";

export async function main(denops: Denops) {
  denops.dispatcher = {
    async test() {
      await denops.cmd("echomsg msg", { msg: "hello" });
    },
  };
  await denops.cmd("echomsg msg", { msg: "loaded" });
}

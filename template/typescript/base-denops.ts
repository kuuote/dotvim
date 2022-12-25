import { Denops } from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/mod.ts";

export const main = async (denops: Denops) => {
  denops.dispatcher = {
    async test() {
      await denops.cmd("echomsg 'hello'");
    },
  };
  await denops.cmd(
    `nnoremap W <Cmd>call denops#request('${denops.name}', 'test', [])<CR>`,
  );
  await denops.cmd("echomsg 'loaded'");
};

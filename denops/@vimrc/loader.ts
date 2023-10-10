import {
  assert,
  is,
} from "/data/vim/repos/github.com/lambdalisue/deno-unknownutil/mod.ts";
import { Denops } from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/mod.ts";
import * as stdpath from "/data/vim/repos/github.com/denoland/deno_std/path/mod.ts";

export function main(denops: Denops) {
  denops.dispatcher = {
    async load(path: unknown, args?: unknown) {
      assert(path, is.String);
      // NOTE: Import module with fragment so that reload works properly.
      // https://github.com/vim-denops/denops.vim/issues/227
      const mod = await import(
        `${stdpath.toFileUrl(path).href}#${performance.now()}`
      );
      await mod.main(denops, args);
    },
  };
}

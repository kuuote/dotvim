import * as stdpath from "../../deno/deno_std/path/mod.ts";
import { Denops } from "../../deno/denops_std/denops_std/mod.ts";
import { assert, is } from "../../deno/unknownutil/mod.ts";

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

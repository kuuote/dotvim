import { assert, is } from "jsr:@core/unknownutil";
import { Denops } from "jsr:@denops/std";
import * as stdpath from "jsr:@std/path";

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

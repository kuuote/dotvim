import { Denops } from "../@deps/denops_std.ts";
import { is, u } from "../@deps/unknownutil.ts";
import * as stdpath from "/data/vim/deps/deno_std/path/mod.ts";

export function main(denops: Denops) {
  denops.dispatcher = {
    async load(path: unknown, args?: unknown) {
      u.assert(path, is.String);
      // NOTE: Import module with fragment so that reload works properly.
      // https://github.com/vim-denops/denops.vim/issues/227
      const mod = await import(
        `${stdpath.toFileUrl(path).href}#${performance.now()}`
      );
      await mod.main(denops, args);
    },
  };
}

import { Denops, vars } from "./deps.ts";
import { select } from "./select.ts";
import { uu } from "./deps.ts";
import { Fzf } from "./deps/fzf.ts";

export async function main(denops: Denops) {
  denops.dispatcher = {
    select(haystack: unknown, needle: unknown): Promise<string[]> {
      uu.ensureArray(haystack, uu.isString);
      uu.ensureString(needle);
      return Promise.resolve(select(haystack, needle));
    },
    fzf(haystack: unknown, needle: unknown): Promise<string[]> {
      uu.ensureArray(haystack, uu.isString);
      uu.ensureString(needle);
      if (needle === "") {
        return Promise.resolve(haystack);
      }
      const fzf = new Fzf(haystack);
      fzf.find(needle);
      return Promise.resolve(fzf.find(needle).map((r) => r.item));
    },
  };
  await vars.g.set(denops, "vimrc#init_denops", true);
}

import { Denops, vars } from "./deps.ts";
import { select } from "./select.ts";
import { uu } from "./deps.ts";

let gathered: string[] = [];

export async function main(denops: Denops) {
  denops.dispatcher = {
    gather(haystack: unknown) {
      uu.ensureArray(haystack, uu.isString);
      gathered = haystack;
      return Promise.resolve();
    },
    select(needle: unknown): Promise<string[]> {
      uu.ensureString(needle);
      return Promise.resolve(select(gathered, needle));
    },
  };
  await vars.g.set(denops, "vimrc#init_denops", true);
}

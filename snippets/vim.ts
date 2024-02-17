import { TSSnippet } from "../denops/@deps/denippet.ts";
import { Denops } from "../denops/@deps/denops_std.ts";

export const snippets: Record<string, TSSnippet> = {
  autoload_function: {
    body: async (denops: Denops) => {
      const path = String(await denops.call("expand", "%:p"));
      const match = path.match(/autoload\/(.+?)\.vim$/);
      if (match == null) {
        return [];
      }
      const fn = match[1].replaceAll("/", "#");

      return [
        `function ${fn}#$0() abort`,
        "endfunction",
      ];
    },
  },
};

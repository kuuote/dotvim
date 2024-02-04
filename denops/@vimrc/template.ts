import { Denops } from "../@deps/denops_std.ts";

export async function main(denops: Denops) {
  denops.dispatcher = {
    async test() {
      await denops.cmd("echomsg msg", { msg: "hello" });
    },
  };
  await denops.cmd("echomsg msg", { msg: "loaded" });
}

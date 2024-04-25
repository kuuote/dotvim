import { Denops } from "../@deps/denops_std.ts";

export function main(denops: Denops) {
  denops.dispatcher = {
    async focus() {
      const pane = Deno.env.get("TMUX_PANE");
      if (pane == null) {
        return;
      }
      await new Deno.Command("tmux", {
        args: ["select-window", "-t", pane],
      }).output();
      await new Deno.Command("tmux", {
        args: ["select-pane", "-t", pane],
      }).output();
    },
  };
}

import { Denops } from "jsr:@denops/std";

export function main(denops: Denops) {
  denops.dispatcher = {
    async detach() {
      await new Deno.Command("tmux", {
        args: ["detach-client"],
      }).output();
    },
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

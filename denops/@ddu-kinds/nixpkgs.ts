import { BaseKind } from "jsr:@shougo/ddu-vim/kind";
import { ActionArguments, ActionFlags } from "jsr:@shougo/ddu-vim/types";

type Never = Record<PropertyKey, never>;

export class Kind extends BaseKind<Never> {
  override actions: Record<
    string,
    (args: ActionArguments<Never>) => Promise<ActionFlags>
  > = {
    open: async (args) => {
      for (const item of args.items) {
        const pkg = item.word;
        const input = [
          `${pkg}.meta.position`,
          `${pkg}.__functor ${pkg}`,
          `${pkg}`,
          "\n",
        ].join("\n");
        const cmd = new Deno.Command("nix", {
          args: [
            "repl",
            "--extra-experimental-features",
            "nix-command flakes",
            "nixpkgs#pkgs",
          ],
          stdin: "piped",
          stdout: "piped",
          stderr: "piped",
        }).spawn();
        const w = cmd.stdin.getWriter();
        await w.write(new TextEncoder().encode(input));
        await w.close();
        const output = await cmd.output();
        const stdout = new TextDecoder().decode(output.stdout);
        const m = stdout.match(/(\/nix\/store\/[^:]+):(\d+)/);
        if (m != null) {
          await args.denops.cmd("tabedit " + m[1]);
          await args.denops.cmd(m[2]);
        }
      }
      return ActionFlags.None;
    },
  };
  override params(): Never {
    return {};
  }
}

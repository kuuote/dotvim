import { BaseSource } from "jsr:@shougo/ddu-vim/source";
import { Item } from "jsr:@shougo/ddu-vim/types";

type Never = Record<PropertyKey, never>;

export class Source extends BaseSource<Never> {
  override kind = "nixpkgs";
  gather(): ReadableStream<Item<unknown>[]> {
    return new ReadableStream({
      start: async (controller) => {
        try {
          const names = await new Deno.Command("nix", {
            args: [
              "eval",
              "--extra-experimental-features",
              "nix-command flakes",
              "--raw",
              "nixpkgs#pkgs",
              "--apply",
              "pkgs: builtins.toJSON (builtins.attrNames pkgs)",
            ],
            stdout: "piped",
            stderr: "null",
          }).output()
            .then(({ stdout }) => new Response(stdout).json()) as string[];
          controller.enqueue(names.map((word) => ({
            word,
          })));
        } finally {
          controller.close();
        }
      },
    });
  }
  params(): Never {
    return {};
  }
}

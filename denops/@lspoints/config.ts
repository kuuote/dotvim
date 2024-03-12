import { BaseExtension, Lspoints } from "../@deps/lspoints.ts";
import { Denops, variable } from "../@deps/denops_std.ts";

export class Extension extends BaseExtension {
  override async initialize(denops: Denops, lspoints: Lspoints) {
    lspoints.settings.patch({
      startOptions: {
        denols: {
          cmd: [await variable.g.get(denops, "denops#deno", "deno"), "lsp"],
          settings: {
            deno: {
              enable: true,
              unstable: true,
            },
          },
        },
        rust_analyzer: {
          cmd: ["rust-analyzer"],
        },
      },
      tracePath: "/tmp/lspoints",
    });
  }
}

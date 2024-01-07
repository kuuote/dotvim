import { BaseExtension, Client, LSP, Lspoints } from "../deps/lspoints.ts";

export class Extension extends BaseExtension {
  override async initialize(denops: Denops, lspoints: Lspoints) {
    lspoints.settings.patch({
      startOptions: {
        denols: {
          cmd: ["deno", "lsp"],
          initializationOptions: {
            enable: true,
            unstable: true,
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

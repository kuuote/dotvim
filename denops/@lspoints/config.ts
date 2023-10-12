import { Denops } from "../../deno/lspoints/denops/lspoints/deps/denops.ts";
import {
  BaseExtension,
  Lspoints,
} from "../../deno/lspoints/denops/lspoints/interface.ts";

export class Extension extends BaseExtension {
  override initialize(_denops: Denops, lspoints: Lspoints) {
    lspoints.settings.patch({
      startOptions: {
        denols: {
          cmd: ["deno", "lsp"],
          initializationOptions: {
            enable: true,
            unstable: true,
          },
        },
        luals: {
          cmd: ["lua-language-server"],
          params: {
            settings: {
              Lua: {
                diagnostics: {
                  globals: ["vim"],
                },
              },
            },
          },
        },
      },
      tracePath: "/tmp/lspoints",
    });
  }
}

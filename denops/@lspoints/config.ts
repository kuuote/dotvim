import { BaseExtension, Lspoints } from "../@deps/lspoints.ts";
import { Denops } from "jsr:@denops/std";
import * as variable from "jsr:@denops/std/variable";

export class Extension extends BaseExtension {
  override async initialize(denops: Denops, lspoints: Lspoints) {
    lspoints.settings.patch({
      startOptions: {
        denols: {
          cmd: [
            "/data/code/deno/lsptrace.ts",
            "/tmp/lsptrace/deno__date__",
            await variable.g.get(denops, "denops#deno", "deno"),
            "lsp",
          ],
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

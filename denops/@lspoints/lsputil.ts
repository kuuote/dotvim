import { Denops } from "../@deps/denops_std.ts";
import { BaseExtension, Lspoints } from "../@deps/lspoints.ts";
import {
  makePositionParams,
  TextDocumentPositionParams,
} from "/data/vim/repos/github.com/uga-rosa/deno-denops-lsputil/lsputil/mod.ts";

export class Extension extends BaseExtension {
  override initialize(denops: Denops, lspoints: Lspoints) {
    lspoints.defineCommands("lsputil", {
      makePositionParams(): Promise<TextDocumentPositionParams> {
        return makePositionParams(denops);
      },
    });
  }
}

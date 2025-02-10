import { BaseExtension, Lspoints } from "../@deps/lspoints.ts";
import { Denops } from "jsr:@denops/std";
import {
  makePositionParams,
  TextDocumentPositionParams,
} from "jsr:@uga-rosa/denops-lsputil";

export class Extension extends BaseExtension {
  override initialize(denops: Denops, lspoints: Lspoints) {
    lspoints.defineCommands("lsputil", {
      makePositionParams(): Promise<TextDocumentPositionParams> {
        return makePositionParams(denops);
      },
    });
  }
}

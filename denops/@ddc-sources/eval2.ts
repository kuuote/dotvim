import { ensureNumber } from "https://deno.land/x/unknownutil@v2.0.0/mod.ts";
import {
  BaseSource,
  GatherArguments,
  GetCompletePositionArguments,
  OnCompleteDoneArguments,
} from "../../deno/ddc.vim/denops/ddc/base/source.ts";
import { Item } from "../../deno/ddc.vim/denops/ddc/types.ts";

type Params = {
  gather: string;
  getCompletePosition?: string;
  onCompleteDone?: string;
  _?: unknown;
};

export class Source extends BaseSource<Params> {
  override getCompletePosition(
    args: GetCompletePositionArguments<Params>,
  ): Promise<number> {
    const id = args.sourceParams.getCompletePosition;
    if (id != null) {
      this.isBytePos = true; // Vim script or Lua world is byte pos
      return args.denops.call("denops#callback#call", id)
        .then(ensureNumber);
    } else {
      this.isBytePos = false;
      return super.getCompletePosition(args);
    }
  }

  override gather(args: GatherArguments<Params>): Promise<Item[]> {
    return args.denops.call(
      "denops#callback#call",
      args.sourceParams.gather,
    ) as Promise<Item[]>;
  }

  override params(): Params {
    return {
      gather: "",
    };
  }

  override async onCompleteDone(
    args: OnCompleteDoneArguments<Params>,
  ) {
    if (args.sourceParams.onCompleteDone != null) {
      await args.denops.call(
        "denops#callback#call",
        args.sourceParams.onCompleteDone,
      );
    }
  }
}

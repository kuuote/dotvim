import {
  BaseSource,
  GatherArguments,
  GetCompletePositionArguments,
  OnCompleteDoneArguments,
} from "../../deno/ddc.vim/denops/ddc/base/source.ts";
import { Item } from "../../deno/ddc.vim/denops/ddc/types.ts";
import { isNumber } from "https://deno.land/x/unknownutil@v2.0.0/mod.ts";

type Params = Record<PropertyKey, never>;

const omitFunction = (
  value: Record<string, unknown>,
): Record<string, unknown> => {
  const ret: Record<string, unknown> = {};
  for (const key in value) {
    if (typeof value[key] !== "function") {
      ret[key] = value[key];
    }
  }
  return ret;
};

export class Source extends BaseSource<Params> {
  override async getCompletePosition(
    args: GetCompletePositionArguments<Params>,
  ): Promise<number> {
    const result = await args.denops.eval(
      "g:vimrc#ddc#get_complete_position(args)",
      { args: omitFunction(args) },
    );
    if (isNumber(result)) {
      this.isBytePos = true; // Vim script or Lua world is byte pos
      return result;
    } else {
      this.isBytePos = false;
      return super.getCompletePosition(args);
    }
  }

  override gather(args: GatherArguments<Params>): Promise<Item[]> {
    return args.denops.eval("g:vimrc#ddc#gather(args)", {
      args: omitFunction(args),
    }) as Promise<Item[]>;
  }

  override params(): Params {
    return {};
  }

  override async onCompleteDone(args: OnCompleteDoneArguments<Params>) {
    await args.denops.eval("vimrc#ddc#on_complete_done(args)", {
      args: omitFunction(args),
    });
  }
}

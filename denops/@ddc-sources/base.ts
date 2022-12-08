import {
  BaseSource,
  GatherArguments,
  GetCompletePositionArguments,
} from "/data/vim/repos/github.com/Shougo/ddc.vim/denops/ddc/base/source.ts";
import { Item } from "/data/vim/repos/github.com/Shougo/ddc.vim/denops/ddc/types.ts";

type Params = {
  _?: unknown;
};

export class Source extends BaseSource<Params> {
  override getCompletePosition(
    args: GetCompletePositionArguments<Params>,
  ): Promise<number> {
    return super.getCompletePosition(args);
  }

  override gather(_args: GatherArguments<Params>): Promise<Item[]> {
    return Promise.resolve([]);
  }

  override params(): Params {
    return {
      _: null,
    };
  }
}

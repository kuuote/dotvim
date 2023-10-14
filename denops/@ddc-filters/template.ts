import {
  BaseFilter,
  FilterArguments,
} from "/data/vim/repos/github.com/Shougo/ddc.vim/denops/ddc/base/filter.ts";
import { Item } from "/data/vim/repos/github.com/Shougo/ddc.vim/denops/ddc/types.ts";

type Never = Record<PropertyKey, never>;

export class Filter extends BaseFilter<Never> {
  filter(args: FilterArguments<Never>): Item[] {
    return [];
  }
  params() {
    return {};
  }
}

import { BaseFilter, FilterArguments } from "jsr:@shougo/ddc-vim/filter";
import { Item } from "jsr:@shougo/ddc-vim/types";

type Never = Record<PropertyKey, never>;

export class Filter extends BaseFilter<Never> {
  filter(args: FilterArguments<Never>): Item[] {
    return [];
  }
  params() {
    return {};
  }
}

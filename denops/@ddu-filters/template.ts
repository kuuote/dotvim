import { BaseFilter, FilterArguments } from "jsr:@shougo/ddu-vim/filter";
import { DduItem } from "jsr:@shougo/ddu-vim/types";

const params = {
  _: null,
};

type Params = typeof params;
// type Params = Record<PropertyKey, never>;

export class Filter extends BaseFilter<Params> {
  filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    return Promise.resolve(args.items);
  }

  params(): Params {
    return params;
    // return {};
  }
}

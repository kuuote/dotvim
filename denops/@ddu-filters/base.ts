import {
  BaseFilter,
  FilterArguments,
} from "../../deno/ddu.vim/denops/ddu/base/filter.ts";
import { DduItem } from "../../deno/ddu.vim/denops/ddu/types.ts";

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    return Promise.resolve(args.items);
  }

  params(): Params {
    return {};
  }
}

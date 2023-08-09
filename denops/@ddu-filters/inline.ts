import {
  BaseFilter,
  FilterArguments,
} from "../../deno/ddu.vim/denops/ddu/base/filter.ts";
import {
  BaseFilterParams,
  DduItem,
} from "../../deno/ddu.vim/denops/ddu/types.ts";

export type Params = {
  filter?:
    | string
    | ((args: FilterArguments<BaseFilterParams>) => Promise<DduItem[]>);
};

export class Filter extends BaseFilter<Params> {
  async filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    const filter = args.filterParams.filter;
    if (typeof filter === "string") {
      return await args.denops.call(
        "denops#callback#call",
        filter,
        args,
      ) as DduItem[];
    } else if (typeof filter === "function") {
      return await filter(args);
    }
    return Promise.resolve(args.items);
  }

  params(): Params {
    return {};
  }
}

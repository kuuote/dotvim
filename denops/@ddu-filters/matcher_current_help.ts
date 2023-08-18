import {
  BaseFilter,
  FilterArguments,
} from "../../deno/ddu.vim/denops/ddu/base/filter.ts";
import { DduItem } from "../../deno/ddu.vim/denops/ddu/types.ts";

type Params = Record<PropertyKey, never>;

type HelpInfo = {
  lang: string;
  path: string;
  pattern: string;
};

export class Filter extends BaseFilter<Params> {
  async filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    const path = await args.denops.call(
      "fnamemodify",
      args.context.bufName,
      ":p",
    );
    return Promise.resolve(
      args.items.filter((item) => (item.action as HelpInfo).path === path),
    );
  }

  params(): Params {
    return {};
  }
}

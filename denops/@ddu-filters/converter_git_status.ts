import { ActionData } from "../@ddu-kinds/git_status.ts";
import { FilterArguments } from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/base/filter.ts";
import {
  BaseFilter,
  DduItem,
  Item,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/types.ts";

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    const items = args.items as Item<ActionData>[];
    const newItems = items.map((item) => {
      const status = String(item.action?.status);
      const display = item.display ?? item.word;
      const newItem = {
        ...item,
        display: status + display,
      };
      if (newItem.highlights != null) {
        newItem.highlights = newItem.highlights.map((hl) => ({
          ...hl,
          col: hl.col + status.length,
        }));
      }
      return newItem;
    });
    return Promise.resolve(newItems as DduItem[]);
  }

  params(): Params {
    return {};
  }
}

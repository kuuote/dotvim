import {
  BaseFilter,
  FilterArguments,
} from "../../deno/ddu.vim/denops/ddu/base/filter.ts";
import { DduItem, ItemHighlight } from "../../deno/ddu.vim/denops/ddu/types.ts";

type Never = Record<PropertyKey, never>;

export type Params = {
  highlightMatched: string;
  minMatchHighlightLength: number;
};

function equals(a?: ItemHighlight, b?: ItemHighlight) {
  if (a == null || b == null) {
    return false;
  }
  if (a.name == b.name && a.hl_group == b.hl_group) {
    return true;
  } else {
    return false;
  }
}

export class Filter extends BaseFilter<Never> {
  filter(args: FilterArguments<Never>): DduItem[] {
    const filtered = args.items.map((item) => {
      if (item.highlights == null || item.highlights.length == 0) {
        return item;
      }
      const hlmap = Array<ItemHighlight | undefined>();
      for (const hl of item.highlights) {
        for (let i = hl.col; i < hl.col + hl.width; i++) {
          hlmap[i] = hl;
        }
      }
      const highlights: ItemHighlight[] = [];
      let start = 1;
      for (let i = 1; i <= hlmap.length; i++) {
        if (!equals(hlmap[start], hlmap[i])) {
          const hlstart = hlmap[start];
          if (hlstart != null) {
            highlights.push({
              name: hlstart.name,
              hl_group: hlstart.hl_group,
              col: start,
              width: i - start,
            });
          }
          start = i;
        }
      }
      return {
        ...item,
        highlights,
      }
    });
    return filtered;
  }

  params(): Never {
    return {};
  }
}

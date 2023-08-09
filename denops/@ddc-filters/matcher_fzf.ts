import {
  BaseFilter,
  Item,
  PumHighlight,
  SourceOptions,
} from "../../deno/ddc.vim/denops/ddc/types.ts";
import { Fzf } from "https://esm.sh/fzf@0.5.1";

type Params = {
  highlightMatched: string;
};

export class Filter extends BaseFilter<Params> {
  filter(args: {
    sourceOptions: SourceOptions;
    filterParams: Params;
    completeStr: string;
    items: Item[];
  }): Promise<Item[]> {
    const fzf = new Fzf(args.items, {
      selector: (item) => item.word,
    });
    const entries = fzf.find(args.completeStr);
    const items = entries.map((e) => {
      const highlights: PumHighlight[] = [...e.positions]
        .sort()
        .map((n) => ({
          name: "matched",
          type: "abbr",
          "hl_group": args.filterParams.highlightMatched,
          col: n,
          width: 1,
        }));
      return { ...e.item, highlights };
    });
    return Promise.resolve(items);
  }

  params(): Params {
    return {
      highlightMatched: "FuzzyAccent",
    };
  }
}

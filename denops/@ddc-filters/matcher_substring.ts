import {
  BaseFilter,
  Item,
  PumHighlight,
  SourceOptions,
} from "../../deno/ddc.vim/denops/ddc/types.ts";

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
    const ignoreCase = args.sourceOptions.ignoreCase;
    let cmp = args.completeStr.split(/\s+/);
    if (ignoreCase) {
      cmp = cmp.map((w) => w.toLowerCase());
    }

    return Promise.resolve(args.items.flatMap((item) => {
      const word = ignoreCase ? item.word.toLowerCase() : item.word;
      const highlights: PumHighlight[] = [];
      let pos = 0;
      for (let i = 0; i < cmp.length; i++) {
        const idx = word.indexOf(cmp[i], pos);
        if (idx === -1) {
          return [];
        }
        pos = idx + cmp[i].length;
        highlights.push({
          name: "matched",
          type: "abbr",
          "hl_group": args.filterParams.highlightMatched,
          col: idx,
          width: cmp[i].length,
        });
      }
      return [{
        ...item,
        highlights,
      }];
    }));
  }

  params(): Params {
    return {
      highlightMatched: "",
    };
  }
}

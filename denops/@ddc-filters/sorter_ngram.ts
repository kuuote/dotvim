import {
  BaseFilter,
  FilterArguments,
} from "../../deno/ddc.vim/denops/ddc/base/filter.ts";
import { Item } from "../../deno/ddc.vim/denops/ddc/types.ts";
import { makeTrie, match } from "../@kuuote/ngram.ts";

function byteLength(input: string): number {
  return new TextEncoder().encode(input).length;
}

export type Params = {
  highlightMatched: string;
  minMatchLength: number;
  minMatchHighlightLength: number;
};

export class Filter extends BaseFilter<Params> {
  filter(args: FilterArguments<Params>): Item[] {
    if (args.completeStr.length < args.filterParams.minMatchLength) {
      return args.items;
    }
    const input = args.sourceOptions.ignoreCase
      ? args.completeStr.toLowerCase()
      : args.completeStr;
    const needle = makeTrie(input);
    const ranked = args.items.map((item) => {
      const word = args.sourceOptions.ignoreCase
        ? item.word.toLowerCase()
        : item.word;
      const result = match(word, needle, {
        minMatchLength: args.filterParams.minMatchLength,
      });
      return {
        item,
        result,
      };
    });

    const hl_group = args.filterParams.highlightMatched;
    if (hl_group != "") {
      const name = "ddc-filter-sorter_ngram-" + hl_group;
      for (const { item, result } of ranked) {
        item.highlights ??= [];
        for (const m of result.matches) {
          if (args.filterParams.minMatchHighlightLength <= m.len) {
            item.highlights.push({
              name,
              type: "abbr",
              hl_group,
              col: 1 + byteLength(item.word.slice(0, m.start)),
              width: byteLength(m.text),
            });
          }
        }
      }
    }

    return ranked.sort((a, b) => b.result.score - a.result.score)
      .map((value) => value.item);
  }

  params(): Params {
    return {
      highlightMatched: "",
      minMatchLength: 1,
      minMatchHighlightLength: 1,
    };
  }
}

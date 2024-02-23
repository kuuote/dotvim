import {
  BaseFilter,
  FilterArguments,
} from "https://deno.land/x/ddu_vim@v3.10.0/base/filter.ts";
import { DduItem } from "https://deno.land/x/ddu_vim@v3.10.0/types.ts";
import { makeTrie, match } from "./ngram/ngram.ts";

function byteLength(input: string): number {
  return new TextEncoder().encode(input).length;
}

export type Params = {
  highlightMatched: string;
  minMatchLength: number;
  minMatchHighlightLength: number;
};

export class Filter extends BaseFilter<Params> {
  filter(args: FilterArguments<Params>): DduItem[] {
    if (args.input.length < args.filterParams.minMatchLength) {
      return args.items;
    }
    const ignoreCase = args.sourceOptions.ignoreCase &&
      !(args.sourceOptions.smartCase && /[A-Z]/.test(args.input));
    const input = ignoreCase ? args.input.toLowerCase() : args.input;
    const needle = makeTrie(input);
    const ranked = args.items.map((item) => {
      const key = ignoreCase ? item.matcherKey.toLowerCase() : item.matcherKey;
      const result = match(key, needle, {
        minMatchLength: args.filterParams.minMatchLength,
      });
      return {
        item,
        result,
      };
    });

    const hl_group = args.filterParams.highlightMatched;
    if (hl_group != "") {
      const name = "ddu-filter-ngram-" + hl_group;
      for (const { item, result } of ranked) {
        item.highlights ??= [];
        for (const m of result.matches) {
          if (args.filterParams.minMatchHighlightLength <= m.len) {
            item.highlights.push({
              name,
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

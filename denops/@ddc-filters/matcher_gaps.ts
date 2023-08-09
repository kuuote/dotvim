import {
  BaseFilter,
  FilterArguments,
} from "../../deno/ddc.vim/denops/ddc/base/filter.ts";
import { Item } from "../../deno/ddc.vim/denops/ddc/types.ts";

type Params = {
  acceptGaps: number;
};

export function match(haystack: string, needle: string): number[] {
  const matches: number[] = [];
  let pos = 0;
  for (const c of needle) {
    const p = haystack.indexOf(c, pos);
    if (p !== -1) {
      matches.push(p);
      pos = p;
    }
  }
  return matches;
}

export class Filter extends BaseFilter<Params> {
  filter({
    completeStr,
    filterParams,
    items,
    sourceOptions,
  }: FilterArguments<Params>): Promise<Item[]> {
    if (completeStr.length < 1) {
      return Promise.resolve(items);
    }
    const input = sourceOptions.ignoreCase
      ? completeStr.toLowerCase()
      : completeStr;
    const a = items
      .map((item) => {
        const word = sourceOptions.ignoreCase
          ? item.word.toLowerCase()
          : item.word;
        const matches = match(word, input);
        return {
          item,
          matches,
        };
      })
      .flatMap((val) =>
        val.matches.length >= input.length - filterParams.acceptGaps
          ? val.item
          : []
      );
    return Promise.resolve(a);
  }

  params(): Params {
    return {
      acceptGaps: 2,
    };
  }
}

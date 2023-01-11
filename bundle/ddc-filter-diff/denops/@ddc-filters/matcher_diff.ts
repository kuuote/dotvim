import { difference } from "./filter-diff/onp.ts";
import { commonString, findShortest } from "./filter-diff/shorten.ts";
import {
  BaseFilter,
  FilterArguments,
} from "https://deno.land/x/ddc_vim@v3.4.0/base/filter.ts";
import { Item } from "https://deno.land/x/ddc_vim@v3.4.0/types.ts";

type Params = {
  threshold: number;
};

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
        const short = findShortest(word, commonString(word, input));
        const common = word.slice(short[0], (short.at(-1) ?? -1) + 1);
        const diff = difference(input, common);
        return {
          item,
          distance: diff.distance / input.length,
        };
      })
      .flatMap((val) => val.distance < filterParams.threshold ? val.item : []);
    return Promise.resolve(a);
  }

  params(): Params {
    return {
      threshold: 0.5,
    };
  }
}

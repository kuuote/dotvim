import {
  BaseFilter,
  FilterArguments,
} from "https://deno.land/x/ddc_vim@v3.4.0/base/filter.ts";
import { Item } from "https://deno.land/x/ddc_vim@v3.4.0/types.ts";
import { difference } from "./filter-diff/onp.ts";

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  filter({
    completeStr,
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
        const diff = difference(input, word);
        return {
          item,
          distance: diff.distance / Math.max(input.length, word.length),
        };
      })
      .sort((a, b) => a.item.word.length - b.item.word.length)
      .sort((a, b) => a.distance - b.distance)
      .map(({ item }) => item);
    return Promise.resolve(a);
  }

  params(): Params {
    return {};
  }
}

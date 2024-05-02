import {
  BaseFilter,
  FilterArguments,
} from "https://deno.land/x/ddu_vim@v3.5.0/base/filter.ts";
import { Context, DduItem } from "https://deno.land/x/ddu_vim@v3.5.0/types.ts";

const defaultParams = {
  disableAtNarrowing: false,
};

type Params = typeof defaultParams;

export class Filter extends BaseFilter<Params> {
  #cache = new WeakMap<Context, Map<string, number>>();

  filter(args: FilterArguments<Params>): DduItem[] {
    if (args.filterParams.disableAtNarrowing && args.input !== "") {
      return args.items;
    }
    const cache = this.#cache.get(args.context) ?? new Map();
    this.#cache.set(args.context, cache);
    return args.items.toSorted((a, b) => {
      const ai = cache.get(a.word) ?? Math.random();
      cache.set(a.word, ai);
      const bi = cache.get(b.word) ?? Math.random();
      cache.set(b.word, bi);
      return ai - bi;
    });
  }

  params(): Params {
    return defaultParams;
  }
}

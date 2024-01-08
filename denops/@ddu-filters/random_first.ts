import {
  BaseFilter,
  FilterArguments,
} from "https://deno.land/x/ddu_vim@v3.5.0/base/filter.ts";
import { Context, DduItem } from "https://deno.land/x/ddu_vim@v3.5.0/types.ts";

type Never = Record<PropertyKey, never>;

export class Filter extends BaseFilter<Never> {
  #cache = new WeakMap<Context, Map<string, number>>();

  filter(args: FilterArguments<Never>): DduItem[] {
    if (args.input !== "") {
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

  params(): Never {
    return {};
  }
}

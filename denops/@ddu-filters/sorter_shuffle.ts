import { BaseFilter, FilterArguments } from "jsr:@shougo/ddu-vim/filter";
import { Context, DduItem } from "jsr:@shougo/ddu-vim/types";

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

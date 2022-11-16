import { BaseFilter, Item } from "https://deno.land/x/ddc_vim@v3.1.0/types.ts";

const rank: Record<string, number> = {
  dir: 1,
  file: 2,
  "sym=dir": 3,
  "sym=file": 4,
  symlink: 5,
};

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  filter(args: {
    items: Item[];
  }): Promise<Item[]> {
    return Promise.resolve(args.items.sort((a, b) => {
      const r = (rank[String(a.kind)] ?? 6) - (rank[String(b.kind)] ?? 6);
      if (r !== 0) {
        return r;
      }
      return a.word.localeCompare(b.word);
    }));
  }

  params(): Params {
    return {};
  }
}
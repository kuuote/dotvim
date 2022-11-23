import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v2.0.0/deps.ts";

type Params = Record<never, never>;

const find = (haystack: string, needle: string): number[] => {
  const n = needle[0];
  const eedle = [...needle.slice(1)];
  const indexes = [...haystack].flatMap((c, i) => c === n ? [i] : []);
  return indexes
    .map((i) => {
      let pos = i + 1;
      const found = [i];
      let npos = 0;
      while (pos < haystack.length && npos < eedle.length) {
        if (haystack[pos] === eedle[npos]) {
          found.push(pos);
          npos += 1;
        }
        pos += 1;
      }
      return found;
    })
    .filter((found) => found.length === needle.length)
    .sort((a, b) => (a.at(-1)! - a.at(0)!) - b.at(-1)! - b.at(0)!)[0] ?? [];
};

const charposToBytepos = (input: string, pos: number): number => {
  return (new TextEncoder()).encode(input.slice(0, pos)).length;
};

export class Filter extends BaseFilter<Params> {
  filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    const input = args.sourceOptions.ignoreCase
      ? args.input.toLowerCase()
      : args.input;
    return Promise.resolve(
      args.items.map((item) => {
        const found = find(
          args.sourceOptions.ignoreCase ? item.word.toLowerCase() : item.word,
          input,
        );
        const distance = found.length === 0
          ? Number.POSITIVE_INFINITY
          : found.at(-1)! - found.at(0)!;
        return {
          item: {
            ...item,
            highlights: (item.highlights?.filter((hl) =>
              hl.name != "matched"
            ) ?? [])
              .concat(found.map((i) => ({
                name: "matched",
                "hl_group": "Search",
                col: charposToBytepos(item.word, i) + 1,
                width: new TextEncoder().encode(item.word[i]).length,
              }))),
          },
          distance,
        };
      })
        .sort((a, b) => a.distance - b.distance)
        .map(({ item }) => item),
    );
  }

  params(): Params {
    return {};
  }
}

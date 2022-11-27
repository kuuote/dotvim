import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v2.0.0/deps.ts";

// 単純な歯抜けフィルター

type Params = Record<never, never>;

const find = (haystack: string, needle: string): number[] => {
  let pos = 0;
  let npos = 0;
  const found: number[] = [];
  while (pos < haystack.length && npos < needle.length) {
    if (haystack[pos] === needle[npos]) {
      found.push(pos);
      npos++;
    }
    pos++;
  }
  return found;
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
      args.items.flatMap((item) => {
        const found = find(
          args.sourceOptions.ignoreCase ? item.word.toLowerCase() : item.word,
          input,
        );
        if (found.length !== input.length) {
          return [];
        }
        return [{
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
        }];
      }),
    );
  }

  params(): Params {
    return {};
  }
}

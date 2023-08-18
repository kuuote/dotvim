import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "../../deno/ddu.vim/denops/ddu/types.ts";
import { Denops } from "../../deno/ddu.vim/denops/ddu/deps.ts";

// 単純な歯抜けフィルター

type Params = Record<PropertyKey, never>;

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

function byteLength(input: string): number {
  return new TextEncoder().encode(input).length;
}

export class Filter extends BaseFilter<Params> {
  filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    const inputs =
      (args.sourceOptions.ignoreCase ? args.input.toLowerCase() : args.input)
        .split(/\s+/);
    return Promise.resolve(
      args.items.flatMap((item) => {
        const key = args.sourceOptions.ignoreCase
          ? item.matcherKey.toLowerCase()
          : item.matcherKey;
        let display = item.display ?? item.word;
        display = args.sourceOptions.ignoreCase
          ? display.toLowerCase()
          : display;
        const founds: number[] = [];
        for (const input of inputs) {
          const found = find(key, input);
          if (found.length !== input.length) {
            return [];
          }
          founds.push(...found);
        }
        return [{
          ...item,
          highlights: (item.highlights?.filter((hl) =>
            hl.name != "matched"
          ) ?? [])
            .concat(
              [...new Set(founds)].map((i) => ({
                name: "matched",
                "hl_group": "Search",
                col: byteLength(display.slice(0, i)) + 1,
                width: byteLength(display[i]),
              })),
            ),
        }];
      }),
    );
  }

  params(): Params {
    return {};
  }
}

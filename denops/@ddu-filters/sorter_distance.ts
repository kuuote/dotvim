import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v2.0.0/deps.ts";

// 可能な歯抜けマッチの内最短距離を選ぶsorter

type Bonus = {
  sequence?: number;
};

type Params = {
  highlightMatched?: string;
  bonus?: Bonus;
};

type Result = {
  distance: number;
  score: number;
  matches: number[];
};

function find(haystack: string, needle: string, bonus?: Bonus): Result {
  let current = Number.POSITIVE_INFINITY;
  let score = 0;
  let currentMatches: number[] = [];
  const matches = Array.from(
    Array(needle.length),
    () => Number.NEGATIVE_INFINITY,
  );
  let pos = 0;
  let npos = 0;
  while (pos < haystack.length && npos < needle.length) {
    if (haystack[pos] === needle[npos]) {
      matches[npos++] = pos;
      // 前回のマッチ結果を再利用する
      // 現在のマッチより次のマッチが大きければ結果は変わらないので飛ばす
      if (npos === needle.length || pos < matches[npos]) {
        const distance = matches[needle.length - 1] - matches[0];
        if (distance <= current) {
          current = distance;
          currentMatches = [...matches];
        }
        // マッチの先頭の直後からやり直し
        pos = matches[0] + 1;
        npos = 0;
      }
    }
    pos++;
  }
  if (bonus?.sequence != null) {
    const b = bonus.sequence;
    for (let i = 0; i < currentMatches.length; i++) {
      if (currentMatches[i] - currentMatches[i - 1] === 1) {
        score += b;
      }
    }
  }
  return {
    distance: current,
    score,
    matches: currentMatches,
  };
}

function byteLength(input: string): number {
  return new TextEncoder().encode(input).length;
}

export class Filter extends BaseFilter<Params> {
  filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    filterParams: Params;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    const inputs =
      (args.sourceOptions.ignoreCase ? args.input.toLowerCase() : args.input)
        .split(/\s+/);
    const hl = args.filterParams.highlightMatched;
    return Promise.resolve(
      args.items.map((item) => {
        const word = args.sourceOptions.ignoreCase
          ? item.word.toLowerCase()
          : item.word;
        const matches: number[] = [];
        let result: Result = {
          matches: [],
          distance: Number.POSITIVE_INFINITY,
          score: Number.NEGATIVE_INFINITY,
        };
        for (const input of inputs) {
          result = find(word, input, args.filterParams.bonus);
          matches.push(...result.matches);
        }
        return {
          item: {
            ...item,
            highlights: hl
              ? (item.highlights?.filter((hl) => hl.name !== "matched") ?? [])
                .concat([...new Set(matches)].map((i) => ({
                  name: "matched",
                  "hl_group": "Search",
                  col: byteLength(item.word.slice(0, i)) + 1,
                  width: byteLength(item.word[i]),
                })))
              : item.highlights,
          },
          result,
        };
      })
        .sort((a, b) => {
          const score = b.result.score - a.result.score;
          if (score !== 0) {
            return score;
          }
          return a.result.distance - b.result.distance;
        })
        .map(({ item }) => item),
    );
  }

  params(): Params {
    return {
      bonus: {},
    };
  }
}

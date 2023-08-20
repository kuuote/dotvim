import {
  BaseFilter,
  FilterArguments,
} from "../../deno/ddu.vim/denops/ddu/base/filter.ts";
import { DduItem } from "../../deno/ddu.vim/denops/ddu/types.ts";

type Trie = {
  next: Record<string, Trie>;
};

function makeTrie(input: string): Trie {
  const root: Trie = {
    next: {},
  };
  for (; input.length != 0; input = input.slice(1)) {
    let current = root;
    for (let i = 0; i < input.length; i++) {
      const c = input[i];
      current.next[c] ??= {
        next: {},
      };
      current = current.next[c];
    }
  }
  return root;
}

type MatchResult = {
  start: number;
  len: number;
  text: string;
};

function match(input: string, trie: Trie): MatchResult[] {
  const result: MatchResult[] = [];
  const root = trie;
  let current = root;
  let len = 0;

  // 終了後にチェックするのがめんどいので末尾+1まで処理させる
  for (let i = 0; i <= input.length; i++) {
    const c = input[i];
    if (current.next[c] == null) {
      if (len != 0) {
        result.push({
          start: i - len,
          len,
          text: input.slice(i - len, i),
        });
      }
      len = 0;
      current = root;
    }
    if (current.next[c] != null) {
      current = current.next[c];
      len += 1;
    }
  }
  return result;
}

console.log(match("fzf", makeTrie("fz")));

function byteLength(input: string): number {
  return new TextEncoder().encode(input).length;
}

export type Params = {
  highlightMatched: string;
  minMatchLength: number;
  minMatchHighlightLength: number;
};

export class Filter extends BaseFilter<Params> {
  filter(args: FilterArguments<Params>): DduItem[] {
    if (args.input.length < args.filterParams.minMatchLength) {
      return args.items;
    }
    const ignoreCase = args.sourceOptions.ignoreCase &&
      !(args.sourceOptions.smartCase && /[A-Z]/.test(args.input));
    const input = ignoreCase ? args.input.toLowerCase() : args.input;
    const trie = makeTrie(input);
    const ranked = args.items.map((item) => {
      const key = ignoreCase ? item.matcherKey.toLowerCase() : item.matcherKey;
      const result = match(key, trie)
        .filter((m) => m.len >= args.filterParams.minMatchLength);
      // 類似度と言っても、重複の多い文字列が優先されるのも嬉しくないので
      // score matrixっぽいことをやってみる
      const score = [...input].map(() => 0);
      for (const r of result) {
        const idx = input.indexOf(r.text);
        for (let i = idx; i < idx + r.len; i++) {
          score[i] = Math.max(score[i], r.len);
        }
      }
      return {
        item,
        result,
        score: score.reduce((acc, s) => acc + s),
      };
    });

    const hl_group = args.filterParams.highlightMatched;
    if (hl_group != "") {
      const name = "ddu-filter-sorter_ngram-" + hl_group;
      for (const { item, result } of ranked) {
        item.highlights ??= [];
        for (const m of result) {
          if (args.filterParams.minMatchHighlightLength <= m.len) {
            item.highlights.push({
              name,
              hl_group,
              col: 1 + byteLength(item.word.slice(0, m.start)),
              width: byteLength(m.text),
            });
          }
        }
      }
    }

    return ranked.sort((a, b) => b.score - a.score)
      .map((value) => value.item);
  }

  params(): Params {
    return {
      highlightMatched: "",
      minMatchLength: 1,
      minMatchHighlightLength: 1,
    };
  }
}

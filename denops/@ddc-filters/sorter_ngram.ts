import { Item, PumHighlight } from "../../deno/ddc.vim/denops/ddc/types.ts";
import {
  BaseFilter,
  FilterArguments,
} from "../../deno/ddc.vim/denops/ddc/base/filter.ts";

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
        });
      }
      len = 0;
      current = root;
    } else {
      current = current.next[c];
      len += 1;
    }
  }
  return result;
}

function byteLength(input: string): number {
  return new TextEncoder().encode(input).length;
}

export type Params = {
  highlightMatched: string;
  minMatchLength: number;
};

export class Filter extends BaseFilter<Params> {
  filter(args: FilterArguments<Params>): Item[] {
    const input = args.sourceOptions.ignoreCase
      ? args.completeStr.toLowerCase()
      : args.completeStr;
    const trie = makeTrie(input);
    const ranked = args.items.map((item) => {
      const word = args.sourceOptions.ignoreCase
        ? item.word.toLowerCase()
        : item.word;
      const result = match(word, trie)
        .filter((m) => m.len >= args.filterParams.minMatchLength);
      return {
        item,
        result,
        score: result.reduce((acc, r) => acc + (r.len * r.len), 0),
      };
    });

    const hl_group = args.filterParams.highlightMatched;
    if (hl_group != "") {
      const name = "ddc-filter-sorter_ngram-" + hl_group;
      for (const { item, result } of ranked) {
        item.highlights ??= [];
        for (const m of result) {
          item.highlights.push({
            name,
            type: "abbr",
            hl_group,
            col: 1 + byteLength(item.word.slice(0, m.start)),
            width: byteLength(item.word.slice(m.start, m.start + m.len)),
          });
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
    };
  }
}

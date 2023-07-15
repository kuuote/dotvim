import {
  BaseFilter,
  FilterArguments,
} from "../../deno/ddc.vim/denops/ddc/base/filter.ts";
import { Item } from "../../deno/ddc.vim/denops/ddc/types.ts";

type Params = {
  highlightMatched: string;
};

type MatchResult = {
  matches: number[];
  score: number;
};

// pre allocate memory for minimize GC
// slab idea from fzf, size too.
const slab = new Uint16Array(100 * 1024);

// 多分アルファベットと数字しか打たないのでこれだけでいい
function charClass(c: string): number {
  if (c.match(/[a-z]/)) {
    return 0;
  }
  if (c.match(/[A-Z]/)) {
    return 1;
  }
  if (c.match(/[0-9]/)) {
    return 2;
  }
  return -1;
}

// 計算量を減らすため2つの文字列間でマッチしない文字を取り除く
export function commonString(haystack: string, needle: string): string {
  const matches: string[] = [];
  let pos = 0;
  for (const c of needle) {
    const p = haystack.indexOf(c, pos);
    if (p !== -1) {
      matches.push(c);
      pos = p;
    }
  }
  return matches.join("");
}

// Smith-Waterman algorithm based sequence alignment function
function alignment(
  haystack: string,
  needle: string,
  bonus: number[],
): MatchResult {
  const h = haystack.length + 1;
  const n = needle.length + 1;
  let matrix: Uint16Array;
  if (h * n <= slab.length) {
    matrix = slab.fill(0);
  } else {
    matrix = new Uint16Array(h * n);
  }

  for (let i = 1; i < h; i++) {
    for (let j = 1; j < n; j++) {
      const imjm = (i - 1) + (j - 1) * h;
      const ij = i + j * h;
      const match = haystack[i - 1] === needle[j - 1];
      // 連続マッチのみを処理するように簡略化している
      matrix[ij] = match ? matrix[imjm] + 1 + bonus[i - 1] : 0;
    }
  }

  // trace back
  const match = new Set<number>();
  let score = 0;
  let hmax = haystack.length - 1;
  let npos = needle.length - 1;
  while (npos >= 0) {
    const start = (npos + 1) * h;
    let hpos = hmax;
    for (let hp = hmax - 1; hp >= 0; hp--) {
      const max = matrix[start + hpos + 1];
      const current = matrix[start + hp + 1];
      if (max < current) {
        hpos = hp;
      }
    }

    // 不正確な入力を許容するので探索に失敗したら弾く
    if (haystack[hpos] !== needle[npos]) {
      npos--;
      continue;
    }

    // 隣接数が欲しく、必ず1は加算されるので-1開始にしておく
    let adjacent = -1;
    while (npos >= 0 && haystack[hpos] === needle[npos]) {
      match.add(hpos);
      adjacent += 1;
      score += bonus[hpos];

      hpos--;
      npos--;
      hmax = hpos;
    }
    score += adjacent * 10;
  }

  return {
    matches: [...match].sort((a, b) => a - b),
    score,
  };
}

function byteLength(input: string): number {
  return new TextEncoder().encode(input).length;
}

export class Filter extends BaseFilter<Params> {
  // deno-lint-ignore require-await
  async filter(args: FilterArguments<Params>): Promise<Item[]> {
    const input = args.sourceOptions.ignoreCase
      ? args.completeStr.toLowerCase()
      : args.completeStr;
    const scored = args.items.map((item) => {
      const word = args.sourceOptions.ignoreCase
        ? item.word.toLowerCase()
        : item.word;
      const bonus = [...item.word].map((c, i, it) => {
        // ワードらしき物の始点を加点
        if (i === 0) {
          return 1;
        }
        if (charClass(c) !== charClass(it[i - 1])) {
          return 1;
        }
        return 0;
      });
      const { matches, score } = alignment(
        word,
        commonString(word, input),
        bonus,
      );
      return {
        item,
        matches,
        score,
      };
    }).sort((a, b) => b.score - a.score || b.matches.length - a.matches.length);

    const highlight = args.filterParams.highlightMatched;
    if (highlight !== "") {
      return scored.map((s) => ({
        ...s.item,
        highlights: (s.item.highlights ?? [])
          .concat(s.matches.map((i) => ({
            name: "ddc-filter-sorter_alignment",
            type: "abbr",
            "hl_group": highlight,
            col: byteLength(s.item.word.slice(0, i)) + 1,
            width: byteLength(s.item.word[i]),
          }))),
      }));
    } else {
      return scored.map((s) => s.item);
    }
  }

  params(): Params {
    return {
      highlightMatched: "diffAdded",
    };
  }
}

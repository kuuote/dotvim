import { BaseFilter, FilterArguments, Item } from "../@deps/ddc.ts";
// @deno-types=./sorter_fzf/fzf_type.ts
import { Fzf } from "npm:fzf@0.5.2";

type Never = Record<PropertyKey, never>;

function commonString(haystack: string, needle: string): string {
  haystack = haystack.toLowerCase();
  needle = needle.toLowerCase();
  const matches: string[] = [];
  let pos = 0;
  for (const c of needle) {
    const p = haystack.indexOf(c, pos);
    if (p !== -1) {
      matches.push(c);
      pos = p + 1;
    }
  }
  return matches.join("");
}

function commonString2(haystack: string, needle: string): string {
  const found = [];
  for (let offset = 0; offset < needle.length; offset++) {
    const n = needle.slice(offset);
    const matches = commonString(haystack, n);
    found.push(matches);
    if (matches.length == n.length) {
      break;
    }
  }
  found.sort((a, b) => b.length - a.length);
  return found[0] ?? "";
}

export class Filter extends BaseFilter<Never> {
  filter(args: FilterArguments<Never>): Item[] {
    const a = args.items.map((item, index) => {
      const common = commonString2(item.word, args.completeStr);
      return {
        common,
        index,
        item,
      };
    });
    const b = Map.groupBy(a, (e) => e.common);
    const c = [...b.entries()].map(([key, es]) => {
      const fzf = new Fzf(es, {
        selector: (e) => e.item.word,
        sort: false,
      });
      return fzf.find(key);
    })
      .flat()
      .sort((a, b) => {
        const c = b.item.common.length - a.item.common.length;
        if (c != 0) {
          return c;
        }
        const s = b.score - a.score;
        if (s != 0) {
          return s;
        }
        return a.item.index - b.item.index;
      });
    return c.map((e) => {
      const newItem = { ...e.item.item };
      newItem.highlights = [...e.positions]
        .map((p) => ({
          name: "ddc-filter-sorter_fzf",
          type: "abbr",
          hl_group: "PumHighlight",
          col: p + 1,
          width: 1,
        }));
      return newItem;
    });
  }
  params() {
    return {};
  }
}

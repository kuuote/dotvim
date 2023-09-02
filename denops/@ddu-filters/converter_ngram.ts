import {
  BaseFilter,
  FilterArguments,
} from "../../deno/ddu.vim/denops/ddu/base/filter.ts";
import { DduItem } from "../../deno/ddu.vim/denops/ddu/types.ts";
import { makeTrie, match } from "../@kuuote/ngram.ts";

function byteLength(input: string): number {
  return new TextEncoder().encode(input).length;
}

export type Params = {
  highlightMatched: string;
  minMatchHighlightLength: number;
};

export class Filter extends BaseFilter<Params> {
  filter(args: FilterArguments<Params>): DduItem[] {
    if (args.input.length < 1) {
      return args.items;
    }
    const ignoreCase = args.sourceOptions.ignoreCase &&
      !(args.sourceOptions.smartCase && /[A-Z]/.test(args.input));
    const input = ignoreCase ? args.input.toLowerCase() : args.input;
    const needle = makeTrie(input);
    const ranked = args.items.map((item) => {
      let key = item.display ?? item.matcherKey;
      const ignoreCase = args.sourceOptions.ignoreCase &&
        !(args.sourceOptions.smartCase && /[A-Z]/.test(key));
      key = ignoreCase ? key.toLowerCase() : key;
      const result = match(key, needle);
      return {
        item,
        key,
        result,
      };
    });

    const hl_group = args.filterParams.highlightMatched;
    if (hl_group != "") {
      const name = "ddu-filter-ngram-" + hl_group;
      for (const { item, key, result } of ranked) {
        item.highlights = (item.highlights ?? [])
          .filter((hl) => hl.name != name);
        for (const m of result.matches) {
          if (args.filterParams.minMatchHighlightLength <= m.len) {
            item.highlights.push({
              name,
              hl_group,
              col: 1 + byteLength(key.slice(0, m.start)),
              width: byteLength(m.text),
            });
          }
        }
      }
    }

    return ranked.map((value) => value.item);
  }

  params(): Params {
    return {
      highlightMatched: "",
      minMatchHighlightLength: 2,
    };
  }
}

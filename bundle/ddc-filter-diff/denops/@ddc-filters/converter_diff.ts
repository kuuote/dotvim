import { highlightable } from "./filter-diff/highlight.ts";
import { difference } from "./filter-diff/onp.ts";
import {
  BaseFilter,
  FilterArguments,
} from "https://deno.land/x/ddc_vim@v3.4.0/base/filter.ts";
import { Item } from "https://deno.land/x/ddc_vim@v3.4.0/types.ts";

type Params = {
  highlightCommon: string;
  highlightAdd: string;
  highlightDelete: string;
};

const typeToName = {
  "common": "ddc_diff_common",
  "add": "ddc_diff_add",
  "delete": "ddc_diff_delete",
} as const;

const typeToHighlight = {
  "common": "highlightCommon",
  "add": "highlightAdd",
  "delete": "highlightDelete",
} as const;

export class Filter extends BaseFilter<Params> {
  filter({
    completeStr,
    filterParams,
    items,
    sourceOptions,
  }: FilterArguments<Params>): Promise<Item[]> {
    const input = sourceOptions.ignoreCase
      ? completeStr.toLowerCase()
      : completeStr;
    const a = items
      .map((item) => {
        const word = sourceOptions.ignoreCase
          ? item.word.toLowerCase()
          : item.word;
        const diff = difference(input, word);
        const { text, info } = highlightable(
          diff.ses,
          completeStr,
          item.word,
          true,
        );

        const highlights: typeof item.highlights = info.map((i) => {
          return {
            name: typeToName[i.type],
            type: "abbr",
            "hl_group": filterParams[typeToHighlight[i.type]],
            col: i.col,
            width: i.width,
          };
        });

        return { ...item, abbr: text, highlights };
      });
    return Promise.resolve(a);
  }

  params(): Params {
    return {
      highlightCommon: "Pmenu",
      highlightAdd: "diffAdded",
      highlightDelete: "diffRemoved",
    };
  }
}

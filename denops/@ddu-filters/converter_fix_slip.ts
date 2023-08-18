import {
  BaseFilter,
  FilterArguments,
} from "../../deno/ddu.vim/denops/ddu/base/filter.ts";
import { DduItem } from "../../deno/ddu.vim/denops/ddu/types.ts";

export type Never = Record<PropertyKey, never>;

export class Filter extends BaseFilter<Never> {
  filter(args: FilterArguments<Never>): Promise<DduItem[]> {
    const filtered = args.items.map((item) => {
      const word = args.sourceOptions.ignoreCase
        ? item.word.toLowerCase()
        : item.word;
      const display = String(
        args.sourceOptions.ignoreCase
          ? item.display?.toLowerCase()
          : item.display,
      );
      const idx = display.indexOf(word);
      if (idx == -1) {
        return item;
      }
      const byteLength = new TextEncoder().encode(display.slice(0, idx)).length;
      const newItem = { ...item };
      if (newItem.highlights != null) {
        newItem.highlights = newItem.highlights.map((hl) => ({
          ...hl,
          col: hl.col + byteLength,
        }));
      }
      return newItem;
    });
    return Promise.resolve(filtered);
  }

  params(): Never {
    return {};
  }
}

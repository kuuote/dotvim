import { BaseFilter, DduItem, FilterArguments } from "../@deps/ddu.ts";

const params = {
  group: "",
};

type Params = typeof params;

const encoder = new TextEncoder();

function byteLength(text: string): number {
  return encoder.encode(text).length;
}

export class Filter extends BaseFilter<Params> {
  filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    const group = args.filterParams.group;
    for (const item of args.items) {
      (item.highlights = item.highlights ?? []).unshift({
        name: "ddu-filter-color-" + group,
        col: 1,
        width: byteLength(item.display ?? item.word),
        hl_group: args.filterParams.group,
      });
    }
    return Promise.resolve(args.items);
  }

  params(): Params {
    return params;
  }
}

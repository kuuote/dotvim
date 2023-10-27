import { BaseFilter, DduItem, FilterArguments } from "../deps/ddu.ts";

// live grepなどで候補が膨れ上がって固まるのを防ぐためのmatcher

export type Params = {
  maxItems: number;
};

export class Filter extends BaseFilter<Params> {
  filter(args: FilterArguments<Params>): DduItem[] {
    return args.items.slice(0, args.filterParams.maxItems);
  }
  params() {
    return {
      maxItems: 10000,
    };
  }
}

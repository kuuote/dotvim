import { BaseFilter, DduItem, FilterArguments } from "../@deps/ddu.ts";

type Never = Record<PropertyKey, never>;

export class Filter extends BaseFilter<Never> {
  filter(args: FilterArguments<Never>): Promise<DduItem[]> {
    return Promise.resolve(args.items);
  }

  params(): Never {
    return {};
  }
}

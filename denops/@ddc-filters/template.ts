import { BaseFilter,FilterArguments,Item } from "../deps/ddu.ts";

type Never = Record<PropertyKey, never>;

export class Filter extends BaseFilter<Never> {
  filter(args: FilterArguments<Never>): Item[] {
    return [];
  }
  params() {
    return {};
  }
}

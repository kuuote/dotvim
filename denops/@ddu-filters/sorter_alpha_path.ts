import {
  BaseFilter,
  DduItem,
} from "../deps/ddu.ts";
import { ActionData } from "../deps/ddu-kind-file.ts";

type Params = Record<PropertyKey, never>;

type Item = {
  action?: ActionData;
};

/*
 * like ddu-sorter-alpha but ddu-kind-file base
 * ripgrepなどの実行する度に結果が変わるソースのために作った
 */
export class Filter extends BaseFilter<Params> {
  filter(args: {
    items: DduItem[];
  }): Promise<DduItem[]> {
    return Promise.resolve((args.items as Item[]).sort((a, b) => {
      const cmpPath = (a.action?.path ?? "")
        .localeCompare(b.action?.path ?? "");
      if (cmpPath !== 0) {
        return cmpPath;
      }
      return (a.action?.lineNr ?? 0) - (b.action?.lineNr ?? 0);
    }) as DduItem[]);
  }

  params(): Params {
    return {};
  }
}

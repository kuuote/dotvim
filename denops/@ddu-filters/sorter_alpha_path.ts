import {
  BaseFilter,
  DduItem,
} from "https://deno.land/x/ddu_vim@v1.13.0/types.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.1/file.ts?source";

type Params = Record<never, never>;

type Item = {
  action?: ActionData;
};

/*
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

import {
  BaseFilter,
  DduItem,
} from "../../deno/ddu.vim/denops/ddu/types.ts";
import { ActionData } from "../../deno/ddu-kind-file/denops/@ddu-kinds/file.ts";

type Params = Record<PropertyKey, never>;

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

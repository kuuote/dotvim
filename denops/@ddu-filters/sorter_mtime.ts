import {
  BaseFilter,
  DduItem,
  ItemStatus,
  SourceOptions,
} from "../../deno/ddu.vim/denops/ddu/types.ts";
import { Denops } from "../../deno/ddu.vim/denops/ddu/deps.ts";
import { ActionData } from "../../deno/ddu-kind-file/denops/@ddu-kinds/file.ts";

type Params = Record<PropertyKey, never>;

type Item = {
  action?: ActionData;
  status?: ItemStatus;
};

export class Filter extends BaseFilter<Params> {
  async filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    const vault = new Map<string, Promise<Deno.FileInfo>>();
    const mtime = async (item: Item): Promise<[Item, number]> => {
      const t = item.status?.time;
      if (t != null) {
        return [item, t];
      }
      const path = item.action?.path ?? "";
      // cache path for multiline source(e.g. grep)
      try {
        let stat = vault.get(path);
        if (stat == null) {
          stat = Deno.stat(path);
          vault.set(path, stat);
        }
        return [
          item,
          (await stat).mtime?.getTime() ?? 0,
        ];
      } catch {
        // unknown path is force old
        return [item, 0];
      }
    };
    return (await Promise.all((args.items as Item[]).map(mtime)))
      .sort((a, b) => b[1] - a[1])
      .map((t) => t[0] as DduItem);
  }

  params(): Params {
    return {};
  }
}

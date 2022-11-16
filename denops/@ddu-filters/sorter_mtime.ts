import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v1.13.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v1.13.0/deps.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.1/file.ts?source";

type Params = Record<never, never>;

type Item = {
  action?: ActionData;
};

export class Filter extends BaseFilter<Params> {
  async filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    const mtime = async (item: Item): Promise<[Item, number]> => {
      try {
        return [
          item,
          (await Deno.stat(item.action!.path!)).mtime?.getTime() ?? 0,
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

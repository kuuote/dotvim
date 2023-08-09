import { Denops, fn } from "../../deno/ddc.vim/denops/ddc/deps.ts";
import {
  BaseSource,
  DdcOptions,
  Item,
  SourceOptions,
} from "../../deno/ddc.vim/denops/ddc/types.ts";
import { convertKeywordPattern } from "../../deno/ddc.vim/denops/ddc/util.ts";

/* fork from ddc-source-around */

const cache: Record<number, {
  changedtick: number;
  items: Item[];
}> = {};

function allWords(lines: string[], pattern: string): string[] {
  return lines
    .flatMap((line) => [...line.matchAll(new RegExp(pattern, "gu"))])
    .filter((match) => match[0].length > 0)
    .map((match) => match[0]);
}

export type Params = {
  finder: (denops: Denops) => Promise<number[]>;
};

export class Source extends BaseSource<Params> {
  override async gather(args: {
    denops: Denops;
    options: DdcOptions;
    sourceOptions: SourceOptions;
    sourceParams: Params;
    completeStr: string;
  }): Promise<Item[]> {
    const p = args.sourceParams as unknown as Params;

    // Convert keywordPattern
    const keywordPattern = await convertKeywordPattern(
      args.denops,
      args.sourceOptions.keywordPattern,
    );

    const bufnrs = await p.finder(args.denops);
    const cs: Item[] = [
      ...new Set(
        (await Promise.all(
          bufnrs.map(async (bufnr) => {
            const changedtick = Number(
              await fn.getbufvar(args.denops, bufnr, "changedtick"),
            );
            const cached = cache[bufnr];
            if (cached?.changedtick === changedtick) {
              return cached.items;
            }
            const items = allWords(
              await fn.getbufline(args.denops, bufnr, 1, "$"),
              keywordPattern,
            ).map((word) => ({ word }));
            cache[bufnr] = {
              changedtick,
              items,
            };
            return items;
          }),
        )).flat(),
      ),
    ];

    return cs;
  }

  override params(): Params {
    return {
      finder: () => Promise.resolve([]),
    };
  }
}

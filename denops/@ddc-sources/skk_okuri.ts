import {
  GetCompletePositionArguments,
  OnInitArguments,
} from "../../../../vim/repos/github.com/Shougo/ddc.vim/denops/ddc/base/source.ts";
import {
  BaseSource,
  GatherArguments,
  Item,
  OnCompleteDoneArguments,
} from "../@deps/ddc.ts";
import { is, u } from "../@deps/unknownutil.ts";
import { parse } from "./skk_okuri/dict.ts";
import { getOkuriStr } from "./skk_okuri/okuri.ts";
import { split } from "./skk_okuri/split.ts";

export type Params = {
  candidates: Array<string | Item>;
  callback?: string | ((args: OnCompleteDoneArguments<Params>) => unknown);
};

export class Source extends BaseSource<Params> {
  #dict = new Map<string, string[]>();

  override async onInit(args: OnInitArguments<Params>): Promise<void> {
    this.#dict = await parse(
      "/data/vim/repos/github.com/skk-dev/dict/SKK-JISYO.L",
    );
  }

  override getCompletePosition(
    args: GetCompletePositionArguments<Params>,
  ): number {
    const m = args.context.input.match(/.*;/);
    if (m == null) {
      return -1;
    }
    return m[0].length - 1;
  }

  override async gather(args: GatherArguments<Params>): Promise<Item[]> {
    const kana = args.context.input.match(/(?<=;)[^;]+$/)?.[0];

    const chunks = split(kana ?? "");
    console.log(chunks);
    const candidates = chunks.flatMap(([word, okuri]) => {
      const key = getOkuriStr(word, okuri);
      const cands = this.#dict.get(key);
      if (cands == null) {
        return [];
      }
      return cands.map((c) => ({
        word: c.replace(/;.*$/, "") + okuri,
      }));
    });
    return candidates;
  }

  override params(): Params {
    return {
      candidates: [],
    };
  }
}

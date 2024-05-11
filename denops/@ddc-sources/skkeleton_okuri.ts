import {
  BaseSource,
  GatherArguments,
  GetCompletePositionArguments,
  Item,
} from "../@deps/ddc.ts";
import { parse } from "./skk_okuri/dict.ts";
import { getOkuriStr } from "./skk_okuri/okuri.ts";
import { split } from "./skk_okuri/split.ts";

type Never = Record<PropertyKey, never>;

export class Source extends BaseSource<Never> {
  #dict = new Map<string, string[]>();

  override async onInit(): Promise<void> {
    this.#dict = await parse(
      "/data/vim/repos/github.com/skk-dev/dict/SKK-JISYO.L",
    );
  }

  override async getCompletePosition(
    args: GetCompletePositionArguments<Never>,
  ): Promise<number> {
    const preEditLength = await args.denops.dispatch(
      "skkeleton",
      "getPreEditLength",
    ).catch(() => 0) as number;
    if (preEditLength != 0) {
      return args.context.input.length - preEditLength;
    }
    return -1;
  }

  override async gather(args: GatherArguments<Never>): Promise<Item[]> {
    const kana = String(
      await args.denops.dispatch(
        "skkeleton",
        "getPrefix",
      ),
    );

    const chunks = split(kana ?? "");
    const candidates = chunks.flatMap(([word, okuri]) => {
      const key = getOkuriStr(word, okuri);
      const cands = this.#dict.get(key);
      if (cands == null) {
        return [];
      }
      return cands.map((kana) => {
        const kanaStrip = kana.replace(/;.*$/, "");
        return {
          word: kanaStrip + okuri,
          data: {
            skkeleton_okuri: {
              kana,
              kanaStrip,
              okuri,
            },
          },
        };
      });
    });
    return candidates;
  }

  override params(): Never {
    return {};
  }
}

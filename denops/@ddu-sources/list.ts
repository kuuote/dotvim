import { Callback } from "../@ddu-kinds/callback.ts";
import { BaseSource, GatherArguments } from "jsr:@shougo/ddu-vim/source";
import { DduItem, DduOptions, Item } from "jsr:@shougo/ddu-vim/types";

type Items = Array<string | DduItem>;

type Params = {
  items: Items;
};

export class Source extends BaseSource<Params> {
  override kind = "callback";
  gather(args: GatherArguments<Params>): ReadableStream<Item<unknown>[]> {
    return new ReadableStream({
      start: (controller) => {
        try {
          controller.enqueue(
            args.sourceParams.items.map((item) =>
              typeof item === "object" ? item : {
                word: item,
              }
            ),
          );
        } finally {
          controller.close();
        }
      },
    });
  }
  params(): Params {
    return {
      items: [],
    };
  }
}

export function buildOptions(
  items: Items,
  callback: Callback,
): Partial<DduOptions> {
  return {
    sources: [{
      name: "list",
      params: {
        items,
      },
    }],
    kindParams: {
      callback: {
        callback,
      },
    },
  };
}

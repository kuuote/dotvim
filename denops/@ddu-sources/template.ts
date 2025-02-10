import { BaseSource, GatherArguments } from "jsr:@shougo/ddu-vim/source";
import { Item } from "jsr:@shougo/ddu-vim/types";

type Never = Record<PropertyKey, never>;

export class Source extends BaseSource<Never> {
  override kind = "file";
  gather(args: GatherArguments<Never>): ReadableStream<Item<unknown>[]> {
    return new ReadableStream({
      start: async (controller) => {
        try {
        } finally {
          controller.close();
        }
      },
    });
  }
  params(): Never {
    return {};
  }
}

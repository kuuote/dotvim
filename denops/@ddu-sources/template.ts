import { BaseSource, GatherArguments, Item } from "../deps/ddu.ts";

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

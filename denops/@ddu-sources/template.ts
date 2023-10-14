import {
  BaseSource,
  GatherArguments,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/base/source.ts";
import {
  Item,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/types.ts";

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

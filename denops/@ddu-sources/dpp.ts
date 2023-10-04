import {
  BaseSource,
  GatherArguments,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/base/source.ts";
import {
  Item,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/types.ts";
import {
  ensure,
  is,
} from "/data/vim/repos/github.com/lambdalisue/deno-unknownutil/mod.ts";

type Never = Record<PropertyKey, never>;

export class Source extends BaseSource<Never> {
  override kind = "file";
  gather(args: GatherArguments<Never>): ReadableStream<Item<unknown>[]> {
    return new ReadableStream({
      start: async (controller) => {
        try {
          controller.enqueue(
            ensure(
              await args.denops.eval("g:dpp#_plugins->values()"),
              is.ArrayOf(is.ObjectOf({
                name: is.String,
                path: is.String,
              })),
            ).map((plugin) => ({
              word: plugin.name,
              action: {
                path: plugin.path,
                __name: plugin.name,
              },
            })),
          );
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

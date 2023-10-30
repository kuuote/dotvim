import { BaseSource, GatherArguments, Item } from "../deps/ddu.ts";
import { abortable } from "https://deno.land/std@0.204.0/async/mod.ts";

type Never = Record<PropertyKey, never>;

export class Source extends BaseSource<Never> {
  override kind = "file";
  gather(args: GatherArguments<Never>): ReadableStream<Item<unknown>[]> {
    console.log(`gather start ${Math.random()}`);
    const abortController = new AbortController();
    return new ReadableStream({
      start: async (controller) => {
        try {
          while (true) {
            await abortable(
              new Promise((resolve) => setTimeout(resolve, 1000)),
              abortController.signal,
            );
            controller.enqueue([{
              word: String(Math.random()),
            }]);
          }
        } finally {
          controller.close();
        }
      },
      cancel(reason): void {
        abortController.abort();
        console.log(`gather cancel ${Math.random()}`);
        console.log(reason);
      },
    });
  }
  params(): Never {
    return {};
  }
}

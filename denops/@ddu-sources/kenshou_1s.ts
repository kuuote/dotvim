import { abortable } from "/data/vim/deps/deno_std/async/abortable.ts";
import { BaseSource, Item } from "https://deno.land/x/ddu_vim@v3.6.0/types.ts";

type Never = Record<PropertyKey, never>;

export class Source extends BaseSource<Never> {
  gather(): ReadableStream<Item<unknown>[]> {
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

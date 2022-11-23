import { dirname } from "https://deno.land/std@0.165.0/path/mod.ts";
import { readAll } from "https://deno.land/std@0.165.0/streams/mod.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.1/file.ts";
import { GatherArguments } from "https://deno.land/x/ddu_vim@v2.0.0/base/source.ts";
import { fn } from "https://deno.land/x/ddu_vim@v2.0.0/deps.ts";
import { BaseSource, Item } from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";

type Params = Record<never, never>;

export class Source extends BaseSource<Params> {
  kind = "file";

  gather({
    context,
    denops,
  }: GatherArguments<Params>): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        try {
          const cbuf = await fn.getbufline(denops, context.bufNr, 1, "$");
          cbuf.push(""); // append trailing newline for text file
          const cfile = String(
            await denops.eval(`fnamemodify(bufname(${context.bufNr}), ':p')`),
          );
          const workdir = dirname(cfile);
          const p = Deno.run({
            cmd: ["git", "diff", "--no-index", cfile, "-"],
            cwd: workdir,
            stdin: "piped",
            stdout: "piped",
          });
          p.stdin.write(new TextEncoder().encode(cbuf.join("\n")))
            .finally(() => p.stdin.close());
          const stdout = await readAll(p.stdout);
          const diff = new TextDecoder()
            .decode(stdout)
            .trim()
            .split("\n");
          const chunks = diff.flatMap((l, i) => l.startsWith("@") ? [i] : [])
            .map((li, i, a) => diff.slice(li, a[i + 1]));
          for (const chunk of chunks) {
            const m = chunk[0].match(/\+(\d+)/);
            if (m == null) {
              throw Error("m == null");
            }
            let linum = parseInt(m[0]);
            const header: Item<ActionData> = {
              word: chunk[0],
              action: {
                bufNr: context.bufNr,
                lineNr: linum,
              },
            };
            const lines: Item<ActionData>[] = chunk.slice(1)
              .map((l) => ({
                word: l,
                action: {
                  bufNr: context.bufNr,
                  lineNr: l.startsWith("-") ? linum : linum++,
                },
              }));
            controller.enqueue([header].concat(lines));
          }
          controller.close();
        } catch (e: unknown) {
          console.log(e);
        }
      },
    });
  }

  params(): Params {
    return {};
  }
}

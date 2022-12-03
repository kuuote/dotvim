import { dirname } from "https://deno.land/std@0.166.0/path/mod.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.2/file.ts";
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
        const headFile = await Deno.makeTempFile();
        const worktreeFile = await Deno.makeTempFile();
        try {
          const wbuf = await fn.getbufline(denops, context.bufNr, 1, "$");
          wbuf.push(""); // append trailing newline for text file
          await Deno.writeTextFile(worktreeFile, wbuf.join("\n"));

          const path = String(
            await denops.eval(
              `resolve(fnamemodify(bufname(${context.bufNr}), ':p'))`,
            ),
          );
          const worktree = await new Deno.Command("git", {
            args: ["-C", dirname(path), "rev-parse", "--show-toplevel"],
          }).output().then(({ stdout }) =>
            new TextDecoder().decode(stdout).trim()
          );
          const hbuf = await new Deno.Command("git", {
            args: ["show", `:${path.slice(worktree.length + 1)}`],
            cwd: worktree,
          }).output().then(({ stdout }) => stdout);
          await Deno.writeFile(headFile, hbuf);
          const diff = await new Deno.Command("git", {
            args: ["diff", "--no-index", headFile, worktreeFile],
          }).output().then(({ stdout }) =>
            new TextDecoder()
              .decode(stdout)
              .trim()
              .split("\n")
          );
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
                highlights: l.match(/^[+-]/)
                  ? [{
                    name: "abbr",
                    "hl_group": l.startsWith("-") ? "diffRemoved" : "diffAdded",
                    col: 1,
                    width: new TextEncoder().encode(l).length,
                  }]
                  : [],
              }));
            controller.enqueue([header].concat(lines));
          }
          controller.close();
        } catch (e: unknown) {
          console.log(e);
        } finally {
          await Deno.remove(headFile);
          await Deno.remove(worktreeFile);
        }
      },
    });
  }

  params(): Params {
    return {};
  }
}

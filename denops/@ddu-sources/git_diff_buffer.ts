import { dirname } from "https://deno.land/std@0.166.0/path/mod.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.2/file.ts";
import { GatherArguments } from "https://deno.land/x/ddu_vim@v2.0.0/base/source.ts";
import { fn } from "https://deno.land/x/ddu_vim@v2.0.0/deps.ts";
import {
  BaseSource,
  Item,
  ItemHighlight,
} from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import { parseDiff, splitAtFile } from "./git_diff/git_diff.ts";

type Params = Record<never, never>;

const hls: Record<string, string> = {
  "-": "diffRemoved",
  "+": "diffAdded",
  "@": "diffLine",
};

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
          const splits = splitAtFile(diff);
          if (splits.length === 0) {
            return;
          }
          const data = parseDiff(splits[0]);
          controller.enqueue(data.lines.map((line, idx) => {
            const highlights: ItemHighlight[] = [];
            const hl = hls[line.text[0]];
            if (hl != null) {
              highlights.push({
                name: "abbr",
                "hl_group": hl,
                col: 1,
                width: new TextEncoder().encode(line.text).length,
              });
            }
            return {
              word: line.text,
              action: {
                bufNr: context.bufNr,
                lineNr: line.linum,
                _git_diff: idx, // hack: suppress preview window closer
              },
              highlights,
            };
          }));
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

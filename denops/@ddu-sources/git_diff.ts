import { dirname } from "https://deno.land/std@0.166.0/path/mod.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.2/file.ts";
import { GatherArguments } from "https://deno.land/x/ddu_vim@v2.0.0/base/source.ts";
import {
  BaseSource,
  Item,
  ItemHighlight,
} from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import * as path from "https://deno.land/std@0.167.0/path/mod.ts";
import { parseDiff, splitAtFile } from "./git_diff/git_diff.ts";

type _ActionData = ActionData & {
  _git_diff: number;
};

type Params = {
  cached?: boolean;
  show?: boolean;
};

const hls: Record<string, string> = {
  "-": "diffRemoved",
  "+": "diffAdded",
  "@": "diffLine",
};

const run = async (cmd: string[], cwd?: string): Promise<string> => {
  if (cwd == null) {
    cwd = Deno.cwd();
  }
  const proc = new Deno.Command(cmd[0], {
    args: cmd.slice(1),
    cwd,
  });
  const { stdout } = await proc.output();
  return new TextDecoder().decode(stdout);
};

export class Source extends BaseSource<Params> {
  kind = "file";

  gather({
    context,
    denops,
    sourceParams,
  }: GatherArguments<Params>): ReadableStream<Item<_ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        try {
          let worktree = String(
            await denops.eval(
              `resolve(fnamemodify(bufname(${context.bufNr}), ':p'))`,
            ),
          );
          worktree = Deno.statSync(worktree).isDirectory
            ? worktree
            : dirname(worktree);
          worktree = (await run([
            "git",
            "rev-parse",
            "--show-toplevel",
          ], worktree)).trim();
          const diff = (await run([
            [
              "git",
              sourceParams.show ? "show" : "diff",
              "--no-color",
              "--no-prefix",
              "--no-relative",
              "--no-renames",
            ],
            worktree,
          ].flat())).split("\n");
          const splits = splitAtFile(diff);
          if (splits.length === 0) {
            return;
          }
          for (const lines of splits) {
            const data = parseDiff(lines);
            const fileName = path.join(worktree, data.fileName);
            controller.enqueue([{
              word: lines[0],
              action: {
                lineNr: 1,
                path: fileName,
                _git_diff: -1,
              },
              highlights: [{
                name: "abbr",
                "hl_group": "diffNewFile",
                col: 1,
                width: new TextEncoder().encode(lines[0]).length,
              }],
            }]);
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
                  lineNr: line.linum,
                  path: path.join(worktree, data.fileName),
                  _git_diff: idx, // hack: suppress preview window closer
                },
                highlights,
              };
            }));
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

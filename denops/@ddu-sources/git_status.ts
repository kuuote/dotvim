import { ActionData, PreviewType } from "../@ddu-kinds/git_file.ts";
import { dirname } from "https://deno.land/std@0.160.0/path/mod.ts";
import {
  OnInitArguments,
} from "https://deno.land/x/ddu_vim@v2.0.0/base/source.ts";
import {
  BaseSource,
  Item,
  ItemHighlight,
} from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";

type Params = {
  worktree?: string;
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
  override kind = "git_file";

  private worktree = "";

  override async onInit({
    denops,
    sourceParams,
  }: OnInitArguments<Params>): Promise<void> {
    const cfile = sourceParams.worktree ?? String(await denops.call("expand", "%:p"));
    const type = await Deno.stat(cfile)
      .then((info) => info.isFile ? "file" : "dir")
      .catch(() => "nil");
    let dir: string;
    switch (type) {
      case "file":
        dir = dirname(cfile);
        break;
      case "dir":
        dir = cfile;
        break;
      default:
        dir = String(await denops.call("getcwd"));
    }
    this.worktree = await new Deno.Command("git", {
      args: ["rev-parse", "--show-toplevel"],
      cwd: dir,
    }).output()
      .then(({ stdout }) =>
        new TextDecoder().decode(stdout)
          .trim()
      );
  }

  override gather(): ReadableStream<Array<Item<ActionData>>> {
    return new ReadableStream({
      start: async (controller) => {
        const status = await run([
          "git",
          "-C",
          this.worktree,
          "status",
          "-uall",
          "--porcelain=v1",
        ])
          .then((output) =>
            output.split("\n").filter((line) => line.length !== 0)
          );
        controller.enqueue(status.map((line) => {
          const highlights: ItemHighlight[] = [];
          let previewType: PreviewType = "never";
          // see :Man git-status
          // ddu-ui-ffはVimにおいてhighlight nameが種類ごとに一意であることを要求する
          if (line.match(/^[MTADRC]/)) {
            previewType = "diff_cached";
            highlights.push({
              name: "git_status_add",
              "hl_group": "diffAdded",
              col: 1,
              width: 1,
            });
          }
          if (line.match(/^.[MTADRC]/)) {
            switch (line[1]) {
              case "M":
                previewType = "diff";
                break;
              case "A":
                previewType = "file";
                break;
            }
            highlights.push({
              name: "git_status_remove",
              "hl_group": "diffRemoved",
              col: 2,
              width: 1,
            });
          }
          if (line.startsWith("??")) {
            previewType = "file";
            highlights.push({
              name: "git_status_remove",
              "hl_group": "diffRemoved",
              col: 1,
              width: 2,
            });
          }
          return {
            word: line,
            action: {
              worktree: this.worktree,
              path: line.replace(/^..."?/, "").replace(/"?$/, ""),
              previewType,
            },
            highlights,
          };
        }));
        controller.close();
      },
    });
  }

  override params(): Params {
    return {};
  }
}

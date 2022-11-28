import { ActionData, PreviewType } from "../@ddu-kinds/git_file.ts";
import { dirname } from "https://deno.land/std@0.160.0/path/mod.ts";
import {
  GatherArguments,
  OnInitArguments,
} from "https://deno.land/x/ddu_vim@v2.0.0/base/source.ts";
import {
  BaseSource,
  Item,
  ItemHighlight,
} from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";

type Params = Record<never, never>;

export class Source extends BaseSource<Params> {
  override kind = "git_file";

  private worktree = "";

  override async onInit({ denops }: OnInitArguments<Params>): Promise<void> {
    const cfile = String(await denops.call("expand", "%:p"));
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
        const status = await new Deno.Command("git", {
          args: ["-C", this.worktree, "status", "--porcelain=v1"],
        }).output()
          .then(({ stdout }) =>
            new TextDecoder().decode(stdout)
              .split("\n")
              .filter((line) => line.length !== 0)
          );
        controller.enqueue(status.map((line) => {
          const highlights: ItemHighlight[] = [];
          let previewType: PreviewType = "never";
          // see :Man git-status
          if (line.match(/^[MTADRC]/)) {
            previewType = "diff_cached";
            highlights.push({
              name: "git_status",
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
              name: "git_status",
              "hl_group": "diffRemoved",
              col: 2,
              width: 1,
            });
          }
          if (line.match(/^\?\?/)) {
            previewType = "file";
            highlights.push({
              name: "git_status",
              "hl_group": "diffRemoved",
              col: 1,
              width: 2,
            });
          }
          return {
            word: line,
            action: {
              worktree: this.worktree,
              path: line.slice(3),
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

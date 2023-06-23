import { ActionData } from "../@ddu-kinds/git_status.ts";
import { dirname } from "https://deno.land/std@0.160.0/path/mod.ts";
import { OnInitArguments } from "https://deno.land/x/ddu_vim@v2.0.0/base/source.ts";
import { BaseSource, Item } from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";

const defaultParams = {
  worktree: "",
};

type Params = typeof defaultParams;

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
  override kind = "git_status";

  private worktree = "";

  override async onInit({
    denops,
    sourceParams,
  }: OnInitArguments<Params>): Promise<void> {
    const type = await Deno.stat(sourceParams.worktree)
      .then((info) => info.isFile ? "file" : "dir")
      .catch(() => "nil");
    let dir: string;
    switch (type) {
      case "file":
        dir = dirname(sourceParams.worktree);
        break;
      case "dir":
        dir = sourceParams.worktree;
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
          const path = line.replace(/^..."?/, "").replace(/"?$/, "");
          return {
            word: path,
            action: {
              path,
              //previewType,
              worktree: this.worktree,
              status: line.slice(0, 3),
            },
          };
        }));
        controller.close();
      },
    });
  }

  override params(): Params {
    return defaultParams;
  }
}

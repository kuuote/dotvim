import * as path from "https://deno.land/std@0.160.0/path/mod.ts";
import { GetPreviewerArguments } from "https://deno.land/x/ddu_vim@v2.0.0/base/kind.ts";
import {
  ActionArguments,
  ActionFlags,
  BaseKind,
  DduItem,
  Previewer,
} from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";

export type PreviewType = "diff" | "diff_cached" | "file" | "never";

export type ActionData = {
  worktree: string;
  path: string;
  previewType: PreviewType;
};

type Params = Record<never, never>;

const getWorktree = (item: DduItem): string => {
  return (item.action as ActionData).worktree;
};

const getPathes = (items: DduItem[]): string[] => {
  return items.map((item) => (item.action as ActionData).path);
};

const run = (args: string[], items: DduItem[]): Promise<Deno.CommandOutput> => {
  return new Deno.Command("git", {
    args: args.concat(getPathes(items)),
    cwd: getWorktree(items[0]),
  }).output();
};

export class Kind extends BaseKind<Params> {
  override actions: Record<
    string,
    (args: ActionArguments<Params>) => Promise<ActionFlags>
  > = {
    add: async (args) => {
      await run(["add"], args.items);
      return ActionFlags.RefreshItems;
    },
    intent_to_add: async (args) => {
      await run(["add", "-N"], args.items);
      return ActionFlags.RefreshItems;
    },
    open: async (args) => {
      const worktree = getWorktree(args.items[0]);
      for (const filePath of getPathes(args.items)) {
        await args.denops.cmd("edit " + path.join(worktree, filePath));
      }
      return ActionFlags.None;
    },
    reset: async (args) => {
      await run(["reset"], args.items);
      return ActionFlags.RefreshItems;
    },
    restore: async (args) => {
      await run(["restore"], args.items);
      return ActionFlags.RefreshItems;
    },
  };

  override async getPreviewer(
    args: GetPreviewerArguments,
  ): Promise<Previewer | undefined> {
    const action = args.item.action as ActionData;
    if (action.previewType === "diff" || action.previewType === "diff_cached") {
      // terminalで出すと微妙になるので出力decodeしてVimのdiff syntaxで出す
      const cmd = new Deno.Command("git", {
        args: [
          ["--no-pager"],
          ["-C", action.worktree],
          ["diff"],
          action.previewType === "diff_cached" ? ["--cached"] : [],
          [action.path],
        ].flat(),
      });
      const lines = await cmd.output()
        .then(({ stdout }) =>
          new TextDecoder().decode(stdout)
            .trim()
            .split("\n")
        );
      return {
        kind: "nofile",
        contents: lines,
        syntax: "diff",
      };
    } else if (action.previewType === "file") {
      return {
        kind: "buffer",
        path: path.join(action.worktree, action.path),
      };
    }
  }

  override params(): Params {
    return {};
  }
}

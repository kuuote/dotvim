import * as path from "https://deno.land/std@0.192.0/path/mod.ts";
import { BaseKind, GetPreviewerArguments } from "https://deno.land/x/ddu_vim@v3.2.7/base/kind.ts";
import {
  ActionArguments,
  ActionFlags,
  DduItem,
  Previewer,
} from "https://deno.land/x/ddu_vim@v3.2.7/types.ts";
import {
  ensure,
  isArrayOf,
  isObjectOf,
  isString,
} from "https://deno.land/x/unknownutil@v3.2.0/mod.ts";

export type ActionData = {
  status: string; // like "MM "
  path: string; // relative path from worktree
  worktree: string; // path to worktree
};

type Params = Record<never, never>;

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

const getWorktree = (item: DduItem): string => {
  return (item.action as ActionData).worktree;
};

const getPathes = (items: DduItem[]): string[] => {
  return items.map((item) => (item.action as ActionData).path);
};

const executeGit = (
  args: string[],
  items: DduItem[],
): Promise<Deno.CommandOutput> => {
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
      await executeGit(["add"], args.items);
      return ActionFlags.RefreshItems;
    },
    executeGit: async (args) => {
      const gitArgs = ensure(
        args.actionParams,
        isObjectOf({
          args: isArrayOf(isString),
        }),
      ).args;
      await executeGit(gitArgs, args.items);
      return ActionFlags.RefreshItems;
    },
    intent_to_add: async (args) => {
      await executeGit(["add", "-N"], args.items);
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
      await executeGit(["reset"], args.items);
      return ActionFlags.RefreshItems;
    },
    restore: async (args) => {
      await executeGit(["restore"], args.items);
      return ActionFlags.RefreshItems;
    },
  };

  override async getPreviewer(
    args: GetPreviewerArguments,
  ): Promise<Previewer | undefined> {
    const action = args.item.action as ActionData;
    let diff = "";
    const diffCached = await run([
      "git",
      "--no-pager",
      "diff",
      "--cached",
      action.path,
    ], action.worktree);
    if (diffCached.trim() !== "") {
      diff = diffCached;
    }
    if (diff === "") {
      diff = await run([
        "git",
        "--no-pager",
        "diff",
        action.path,
      ], action.worktree);
    }
    if (diff.trim() !== "") {
      return {
        kind: "nofile",
        contents: diff.split("\n"),
        syntax: "diff",
      };
    }
    try {
      const filePath = path.join(action.worktree, action.path);
      const stat = await Deno.stat(filePath);
      if (!stat.isFile) {
        return;
      }
      return {
        kind: "buffer",
        path: filePath,
      };
    } catch {
      return;
    }
  }

  override params(): Params {
    return {};
  }
}

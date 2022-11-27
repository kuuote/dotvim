import { GetPreviewerArguments } from "https://deno.land/x/ddu_vim@v2.0.0/base/kind.ts";
import {
  ActionArguments,
  ActionFlags,
  BaseKind,
  DduItem,
TerminalPreviewer,
} from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";

export type ActionData = {
  worktree: string;
  path: string;
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
    reset: async (args) => {
      await run(["reset"], args.items);
      return ActionFlags.RefreshItems;
    },
  };

  override async getPreviewer(args: GetPreviewerArguments): Promise<TerminalPreviewer> {
    return {
      kind: "terminal",
      cmds: ["git", "--no-pager", "-C", getWorktree(args.item), "diff", getPathes([args.item])[0]],
    };
  }

  override params(): Params {
    return {};
  }
}

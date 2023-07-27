import { ActionData as KindFileActionData } from "../../deno/ddu-kind-file/denops/@ddu-kinds/file.ts";
import { Params as DduUiFFParams } from "../../deno/ddu-ui-ff/denops/@ddu-uis/ff.ts";
import { ActionData as GitStatusActionData } from "../../deno/ddu-source-git_status/denops/@ddu-kinds/git_status.ts";
import { ConfigArguments } from "../../deno/ddu.vim/denops/ddu/base/config.ts";
import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
  DduOptions,
} from "../../deno/ddu.vim/denops/ddu/types.ts";
import * as stdpath from "../../deno/deno_std/path/mod.ts";
import * as u from "../../deno/unknownutil/mod.ts";
import { setupFF } from "./ddu/ff.ts";
import { dduHelper } from "./ddu/helper.ts";

type Params = Record<never, never>;

function setupGitStatus(args: ConfigArguments) {
  const ddu = dduHelper(args.denops);
  args.contextBuilder.patchGlobal({
    sourceOptions: {
      git_status: {
        converters: [
          "converter_hl_dir",
          "converter_git_status",
        ],
      },
    },
    kindOptions: {
      git_status: {
        actions: {
          commit: async () => {
            await args.denops.cmd("Gin commit");
            return ActionFlags.None;
          },
          diff: async (args) => {
            const action = args.items[0].action as GitStatusActionData;
            const path = stdpath.join(action.worktree, action.path);
            await ddu.start({
              name: "git_diff",
              sources: [{
                name: "git_diff",
                options: {
                  path,
                },
                params: {
                  ...u.maybe(args.actionParams, u.isRecord) ?? {},
                  onlyFile: true,
                },
              }],
            });
            return ActionFlags.None;
          },
          patch: async (args: ActionArguments<Params>) => {
            for (const item of args.items) {
              const action = item.action as GitStatusActionData;
              await args.denops.cmd("tabnew");
              await args.denops.cmd("tcd " + action.worktree);
              await args.denops.cmd("GinPatch ++no-head " + action.path);
            }
            return ActionFlags.None;
          },
        },
        defaultAction: "open",
      },
    },
  });
}

function setupMRR(args: ConfigArguments) {
  args.setAlias("source", "mrr", "mr");
  args.contextBuilder.patchGlobal({
    sourceOptions: {
      mrr: {
        defaultAction: "file_rec",
      },
    },
    sourceParams: {
      mrr: {
        kind: "mrr",
      },
    },
  });
}

const locals: Record<string, Partial<DduOptions>> = {
  git_diff: {
    uiParams: {
      ff: {
        // どう考えてもでかい差分作る俺が悪いんだが、ハイライト無いと見づらい
        maxHighlightItems: 1000,
      } satisfies Partial<DduUiFFParams>,
    },
  },
};

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const ddu = dduHelper(args.denops);
    // default options
    const defaultMatchers = ["matcher_fzf"];
    const defaultSorters = ["sorter_fzf"];
    args.contextBuilder.patchGlobal({
      actionOptions: {
        applyPatch: { quit: false },
        do: { quit: false },
        narrow: { quit: false },
      },
      filterParams: {
        converter_hl_dir: {
          hlGroup: "String",
        },
        matcher_fzf: {
          highlightMatched: "DduMatch",
        },
        matcher_kensaku: {
          highlightMatched: "DduMatch",
        },
        sorter_distance: {
          bonus: {
            sequence: 1,
          },
          highlightMatched: "DduMatch",
        },
      },
      kindOptions: {
        action: { defaultAction: "do" },
        colorscheme: { defaultAction: "set" },
        command: { defaultAction: "execute" },
        dein_update: { defaultAction: "viewDiff" },
        file: {
          actions: {
            file_rec: async (args: ActionArguments<Params>) => {
              const data = args.items[0].action as KindFileActionData;
              await ddu.start({
                name: "file:file_rec",
                sources: [{
                  name: "file_rec",
                  options: {
                    path: data.path,
                  },
                }],
              });
              return ActionFlags.None;
            },
          },
          defaultAction: "open",
        },
        git_tag: { defaultAction: "switch" },
        help: { defaultAction: "tabopen" },
        source: { defaultAction: "execute" },
        ui_select: { defaultAction: "select" },
        word: { defaultAction: "append" },
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: defaultMatchers,
          sorters: defaultSorters,
        },
        dein: { defaultAction: "file_rec" },
        dein_update: {
          matchers: ["matcher_dein_update"],
        },
        file: {
          converters: [],
          matchers: [],
          sorters: ["sorter_alignment"],
        },
        file_rec: {
          sorters: ["sorter_alpha_path"].concat(defaultSorters),
        },
        mr: {
          converters: ["converter_hl_dir"],
        },
      },
      ui: "ff",
    });

    await setupFF(args);
    setupMRR(args);
    setupGitStatus(args);

    for (const [name, options] of Object.entries(locals)) {
      args.contextBuilder.setLocal(name, options);
    }

    await args.denops.call("ddu#util#print_error", "loaded ddu settings");
  }
}

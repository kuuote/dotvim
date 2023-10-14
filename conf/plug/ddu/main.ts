import {
  ActionFlags,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/types.ts";
import {
  BaseConfig,
  ConfigArguments,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/base/config.ts";
import {
  is,
  maybe,
} from "/data/vim/repos/github.com/lambdalisue/deno-unknownutil/mod.ts";
import { ActionData as GitStatusActionData } from "/data/vim/repos/github.com/kuuote/ddu-source-git_status/denops/@ddu-kinds/git_status.ts";
import { dduHelper } from "./lib/helper.ts";
import * as stdpath from "/data/vim/repos/github.com/denoland/deno_std/path/mod.ts";

// /data/vim/repos/github.com

function setupGitStatus(args: ConfigArguments) {
  const ddu = dduHelper(args.denops);
  args.contextBuilder.patchGlobal({
    filterParams: {
      // X<ddu-filter-converter_hl_dir>
      converter_hl_dir: {
        hlGroup: "String",
      },
      // X<ddu-filter-matcher_fzf>
      matcher_fzf: {
        highlightMatched: "DduMatch",
      },
    },
    sourceOptions: {
      // X<ddu-source-git_status>
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
            //await args.denops.call("funnygit#commit");
            await args.denops.cmd("Gin commit");
            return ActionFlags.None;
          },
          diff: (args) => {
            const action = args.items[0].action as GitStatusActionData;
            const path = stdpath.join(action.worktree, action.path);
            ddu.start({
              name: "git_diff",
              sources: [{
                name: "git_diff",
                options: {
                  path,
                },
                params: {
                  ...maybe(args.actionParams, is.Record) ?? {},
                  onlyFile: true,
                },
              }],
            });
            return Promise.resolve(ActionFlags.None);
          },
          patch: async (args) => {
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
  args.contextBuilder.patchLocal("git_status", {
    actionOptions: {
      add: { quit: false },
      reset: { quit: false },
      restore: { quit: false },
    },
    sources: ["git_status"],
  });
}

// X<ddu-locals>
// L<ddu-ui-ff-aliases> も直す
function setupLocals(args: ConfigArguments) {
  // X<ddu-local-mr>
  for (const type of ["mru", "mrw", "mrr"]) {
    args.contextBuilder.patchLocal(type, {
      sources: [{
        name: "mr",
        params: {
          kind: type,
        },
      }],
    });
  }
  // X<ddu-local-dpp>
  args.contextBuilder.patchLocal("dpp", {
    sources: ["dpp"],
  });
  // X<ddu-local-line>
  args.contextBuilder.patchLocal("line", {
    sources: ["line"],
  });
}

export class Config extends BaseConfig {
  async config(args: ConfigArguments) {
    // default options
    const defaultMatchers = ["matcher_fzf"];
    const defaultSorters = ["sorter_fzf"];
    // X<ddu-global>
    args.contextBuilder.patchGlobal({
      kindOptions: {
        // X<ddu-kind-file>
        file: {
          defaultAction: "open",
        },
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: defaultMatchers,
          sorters: defaultSorters,
        },
      },
    });

    setupGitStatus(args);
    setupLocals(args);
  }
}

import { ActionData as KindFileActionData } from "../../../deno/ddu-kind-file/denops/@ddu-kinds/file.ts";
import { ActionData as GitBranchActionData } from "../../../deno/ddu-source-git_branch/denops/@ddu-kinds/git_branch.ts";
import { ActionData as GitStatusActionData } from "../../../deno/ddu-source-git_status/denops/@ddu-kinds/git_status.ts";
import { ActionData as KindTagActionData } from "../../../deno/ddu-source-tags/denops/@ddu-kinds/tag.ts";
import { Params as DduUiFFParams } from "../../../deno/ddu-ui-ff/denops/@ddu-uis/ff.ts";
import {
  BaseConfig,
  ConfigArguments,
} from "../../../deno/ddu.vim/denops/ddu/base/config.ts";
import {
  ActionFlags,
  DduOptions,
} from "../../../deno/ddu.vim/denops/ddu/types.ts";
import * as stdpath from "../../../deno/deno_std/path/mod.ts";
import { Denops } from "../../../deno/denops_std/denops_std/mod.ts";
import * as u from "../../../deno/unknownutil/mod.ts";
import { dduHelper } from "./lib/helper.ts";

async function loadeno(denops: Denops) {
  const a = await denops.call(
    "globpath",
    await denops.eval("&runtimepath"),
    "denops/**/*.ts",
  )
    .then((s) => String(s).split("\n"));
  const uis = a.map((path) => {
    const ddu = path.match(/@ddu-uis\/(.+)\.ts$/);
    if (ddu != null) {
      return ddu[1];
    }
  })
    .filter(<T>(x: T): x is NonNullable<T> => x != null);
  try {
    await denops.dispatcher.loadExtensions("ui", uis);
  } catch (e: unknown) {
    console.log(e);
  }
  await denops.call("ddu#util#print_error", "preload complete. ready!");
}

// X<ddu-config-git_status>
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
            await args.denops.call("funnygit#commit");
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
                  ...u.maybe(args.actionParams, u.isRecord) ?? {},
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
  });
}

// X<ddu-alias-source-mrr>
function setupMRR(args: ConfigArguments) {
  args.setAlias("source", "mrr", "mr");
  args.contextBuilder.patchGlobal({
    sourceOptions: {
      mrr: {
        converters: ["converter_hl_dir"],
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
  config(args: ConfigArguments) {
    const ddu = dduHelper(args.denops);
    // default options
    const defaultMatchers = ["matcher_fzf"];
    const defaultSorters = ["sorter_fzf"];
    // X<ddu-config-global>
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
        converter_ngram: {
          highlightMatched: "DduMatch",
        },
        matcher_fzf: {
          highlightMatched: "DduMatch",
        },
        matcher_kensaku: {
          highlightMatched: "DduMatch",
        },
        sorter_alignment: {
          highlightMatched: "DduMatch",
        },
        sorter_distance: {
          bonus: {
            sequence: 1,
          },
          highlightMatched: "DduMatch",
        },
        sorter_ngram: {
          highlightMatched: "DduMatch",
          minMatchHighlightLength: 2,
        },
      },
      kindOptions: {
        action: { defaultAction: "do" },
        callback: { defaultAction: "call" },
        colorscheme: { defaultAction: "set" },
        command: { defaultAction: "execute" },
        dein_update: { defaultAction: "viewDiff" },
        file: {
          actions: {
            file_rec: (args) => {
              const data = args.items[0].action as KindFileActionData;
              ddu.start({
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
        // # X<ddu-kind-git_branch>
        git_branch: {
          actions: {
            // original: https://github.com/kyoh86/dotfiles/blob/e78a7fef7338271b389d755ac4499a9f4d0cbfab/nvim/lua/kyoh86/plug/ddu/source/git_branch.lua#L44-L60
            show_log: (args) => {
              const data = args.items[0].action as GitBranchActionData;
              const { refName } = data;
              const branch = refName.remote == ""
                ? refName.branch
                : `${refName.remote}/${refName.branch}`;
              ddu.start({
                name: "git_log",
                sources: [{
                  name: "git_log",
                  params: {
                    startingCommits: [branch],
                  },
                  options: {
                    path: args.sourceOptions.path,
                  },
                }],
              });
              return ActionFlags.None;
            },
          },
          defaultAction: "show_log",
        },
        help: { defaultAction: "tabopen" },
        lsp: { defaultAction: "open" },
        lsp_codeAction: { defaultAction: "apply" },
        source: { defaultAction: "execute" },
        tag: {
          actions: {
            xjump: async (args) => {
              for (const item of args.items) {
                const data = item.action as KindTagActionData;
                await args.denops.cmd("enew");
                await args.denops.cmd("edit " + data.filename);
                await args.denops.cmd("1"); // 検索だと失敗することあるので
                await args.denops.cmd(data.cmd);
                await args.denops.cmd("normal! zz");
              }
              return ActionFlags.None;
            },
          },
          defaultAction: "xjump",
        },
        ui_select: { defaultAction: "select" },
        word: { defaultAction: "append" },
      },
      postFilters: [
        "converter_reduce_highlights",
      ],
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: defaultMatchers,
          sorters: defaultSorters,
        },
        dein: {
          actions: {
            rsync: async (args) => {
              for (const item of args.items) {
                const data = item.action as KindFileActionData;
                const dest = "/tmp/templug/" + item.word;
                await new Deno.Command("rsync", {
                  args: [
                    "--mkpath",
                    "-a",
                    "--delete-before",
                    (data.path ?? "/dev/null") + "/",
                    dest,
                  ],
                }).output();
                await args.denops.cmd("tabedit " + dest);
              }
              return ActionFlags.None;
            },
            templug: async (args) => {
              for (const item of args.items) {
                await args.denops.cmd("tabedit /tmp/templug/" + item.word);
              }
              return ActionFlags.None;
            },
          },
          defaultAction: "file_rec",
        },
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
        git_branch: {
          columns: [
            "git_branch_head",
            "git_branch_remote",
            "git_branch_name",
            "git_branch_upstream",
          ],
        },
        help: {
          matchers: [],
          sorters: ["sorter_ngram"],
        },
        line: {
          matchers: [],
          sorters: ["sorter_ngram"],
          converters: ["converter_ngram"],
        },
        mr: {
          matchers: [],
          sorters: ["sorter_ngram"],
          converters: ["converter_hl_dir"],
        },
      },
      sourceParams: {
        // X<ddu-config-sourceParams-qf>
        qf: {
          format: "%b:%l: %t",
        },
      },
      ui: "ff",
    });

    setupMRR(args);
    setupGitStatus(args);

    for (const [name, options] of Object.entries(locals)) {
      args.contextBuilder.setLocal(name, options);
    }
    loadeno(args.denops);
  }
}

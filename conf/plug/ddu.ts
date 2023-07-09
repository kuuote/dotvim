import { DdcOptions } from "../../deno/ddc.vim/denops/ddc/types.ts";
import { ActionData as KindFileActionData } from "../../deno/ddu-kind-file/denops/@ddu-kinds/file.ts";
import { ActionData as GitStatusActionData } from "../../deno/ddu-source-git_status/denops/@ddu-kinds/git_status.ts";
import { Params as DduUiFFParams } from "../../deno/ddu-ui-ff/denops/@ddu-uis/ff.ts";
import { ConfigArguments } from "../../deno/ddu.vim/denops/ddu/base/config.ts";
import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
  UiActionArguments,
} from "../../deno/ddu.vim/denops/ddu/types.ts";
import * as stdpath from "../../deno/deno_std/path/mod.ts";
import * as autocmd from "../../deno/denops_std/denops_std/autocmd/mod.ts";
import * as fn from "../../deno/denops_std/denops_std/function/mod.ts";
import * as lambda from "../../deno/denops_std/denops_std/lambda/mod.ts";
import { Denops } from "../../deno/denops_std/denops_std/mod.ts";
import * as opt from "../../deno/denops_std/denops_std/option/mod.ts";
import { dduHelper } from "./ddu/helper.ts";

type Params = Record<never, never>;

async function calculateUiSize(
  denops: Denops,
): Promise<[x: number, y: number, width: number, height: number]> {
  const columns = await opt.columns.get(denops);
  const lines = await opt.lines.get(denops);
  // -2は枠の分
  const width = columns - 8 - 2;
  const height = lines - 4 - 2;
  const x = 4;
  const y = 2;
  return [x, y, width, height];
}

async function setUiSize(args: ConfigArguments) {
  if (args.denops.meta.host === "vim") {
    args.contextBuilder.patchGlobal({
      uiParams: {
        ff: {
          previewWidth: Math.floor(await opt.columns.get(args.denops)),
        },
      },
    });
  }
  const [winCol, winRow, winWidth, winHeight] = await calculateUiSize(
    args.denops,
  );
  const halfWidth = Math.floor(winWidth / 2);
  const pileBorder = true; // 外枠と重ねるか否か
  args.contextBuilder.patchGlobal({
    uiParams: {
      ff: {
        winCol,
        winRow,
        winWidth,
        winHeight,
        // fzf-previewやtelescopeみたいなpreviewの出し方をする
        previewWidth: halfWidth,
        previewCol: winCol + winWidth - halfWidth - (pileBorder ? 0 : 1),
        previewRow: winRow + (pileBorder ? 0 : 1),
        previewHeight: winHeight - (pileBorder ? 0 : 2),
      } satisfies Partial<DduUiFFParams>,
    },
  });
}

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
              sources: [{
                name: "file:git_diff",
                options: {
                  path,
                },
                params: {
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
        defaultAction: "diff",
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

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const ddu = dduHelper(args.denops);
    // border idea by @eetann
    // const border = [".", ".", ".", ":", ":", ".", ":", ":"]
    //   .map((c) => [c, "DduBorder"]);

    // +-------------------+
    // | ASCII罫線はいいぞ |
    // +-------------------+
    const border = ["+", "-", "+", "|", "+", "-", "+", "|"]
      .map((c) => [c, "DduBorder"]);
    const nvim = args.denops.meta.host === "nvim";
    // default options
    const defaultMatchers = ["matcher_fzf"];
    const defaultSorters = ["sorter_fzf"];
    args.contextBuilder.patchGlobal({
      actionOptions: {
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
      uiParams: {
        ff: {
          autoAction: {
            name: "preview",
          },
          floatingBorder: border as any, // そのうち直す
          previewFloating: nvim,
          previewFloatingBorder: border as any, // そのうち直す
          previewFloatingZindex: 100,
          previewSplit: "vertical",
          split: "floating",
        } satisfies Partial<DduUiFFParams>,
      },
      uiOptions: {
        ff: {
          actions: {
            myInputAction: async (args: UiActionArguments<Params>) => {
              const denops = args.denops;
              // get actions
              const items = await ddu.uiGetSelectedItems();
              const actions = await ddu.getItemActions(
                args.options.name,
                items,
              );
              // setup ddc
              const bufnr = await fn.bufnr(denops);
              const custom = await denops.dispatch(
                "ddc",
                "getBuffer",
                bufnr,
              ) as Record<number, DdcOptions>;

              try {
                await denops.dispatch(
                  "ddc",
                  "setBuffer",
                  {
                    cmdlineSources: [{
                      name: "list",
                      options: {
                        minAutoCompleteLength: 0,
                      },
                      params: {
                        candidates: actions,
                      },
                    }],
                  } satisfies Partial<DdcOptions>,
                  bufnr,
                );

                await autocmd.define(
                  denops,
                  "CmdlineEnter",
                  "*",
                  "call ddc#map#manual_complete()",
                  {
                    once: true,
                  },
                );
                // action
                const action = await fn.input(denops, "action: ");
                await ddu.itemAction(
                  args.options.name,
                  action,
                  items,
                  {},
                );
              } finally {
                // restore ddc custom
                await denops.dispatch(
                  "ddc",
                  "setBuffer",
                  custom[bufnr] ?? {},
                  bufnr,
                );
              }

              return ActionFlags.Persist;
            },
            useKensaku: async (args: UiActionArguments<Params>) => {
              args.ddu.updateOptions({
                sourceOptions: {
                  _: {
                    matchers: ["matcher_kensaku"],
                  },
                },
              });
              await args.denops.cmd("echomsg 'change to kensaku matcher'");
              return ActionFlags.Persist;
            },
          },
        },
      },
    });

    setupMRR(args);
    setupGitStatus(args);

    // floatwinのサイズをセットするやつ
    const id = lambda.register(args.denops, () => setUiSize(args));
    await autocmd.group(args.denops, "vimrc#ddu.ts", (helper) => {
      helper.remove("*");
      helper.define(
        "VimResized",
        "*",
        `call denops#notify('ddu', '${id}', [])`,
      );
    });
    await setUiSize(args);
    await args.denops.call("ddu#util#print_error", "loaded ddu settings");
  }
}

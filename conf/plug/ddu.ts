import {
  ensure,
  isArrayOf,
  isString,
} from "https://deno.land/x/unknownutil@v3.2.0/mod.ts";
import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
  DduOptions,
  UiActionArguments,
} from "../../deno/ddu.vim/denops/ddu/types.ts";
import { ConfigArguments } from "../../deno/ddu.vim/denops/ddu/base/config.ts";
import { Params as DduUiFFParams } from "../../deno/ddu-ui-ff/denops/@ddu-uis/ff.ts";
import * as autocmd from "../../deno/denops_std/denops_std/autocmd/mod.ts";
import * as lambda from "../../deno/denops_std/denops_std/lambda/mod.ts";
import { Denops } from "../../deno/denops_std/denops_std/mod.ts";
import * as opt from "../../deno/denops_std/denops_std/option/mod.ts";
import { ActionData as GitStatusActionData } from "../../denops/@ddu-kinds/git_status.ts";

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
  args.contextBuilder.patchGlobal({
    uiParams: {
      ff: {
        winCol,
        winRow,
        winWidth,
        winHeight,
        // fzf-previewやtelescopeみたいなpreviewの出し方をする
        previewWidth: Math.floor(winWidth / 2),
        previewCol: 0,
        previewRow: 0,
        previewHeight: 0,
      } satisfies Partial<DduUiFFParams>,
    },
  });
}

async function updateOptions(
  args: ConfigArguments,
  options: Partial<DduOptions>,
) {
  await args.denops.call("ddu#ui#do_action", "updateOptions", options);
}

async function setupGitStatus(args: ConfigArguments) {
  args.setAlias("action", "add", "executeGit");
  args.contextBuilder.patchGlobal({});
}

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    // border idea by @eetann
    const border = [".", ".", ".", ":", ":", ".", ":", ":"]
      .map((c) => [c, "DduBorder"]);
    const nvim = args.denops.meta.host === "nvim";
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
        file: { defaultAction: "open" },
        git_branch: { defaultAction: "switch" },
        git_status: {
          actions: {
            commit: async () => {
              await args.denops.cmd("Gin commit");
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
        git_tag: { defaultAction: "switch" },
        help: { defaultAction: "tabopen" },
        source: { defaultAction: "execute" },
        ui_select: { defaultAction: "select" },
        word: { defaultAction: "append" },
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_fzf"],
          sorters: ["sorter_fzf"],
        },
        dein_update: {
          matchers: ["matcher_dein_update"],
        },
        file: {
          converters: [],
          matchers: [],
          sorters: ["sorter_alignment"],
        },
        git_status: {
          converters: [
            "converter_hl_dir",
            "converter_git_status",
          ],
        },
        mr: {
          converters: ["converter_hl_dir"],
        },
      },
      ui: "ff",
      uiParams: {
        ff: {
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
            useKensaku: async () => {
              await updateOptions(args, {
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

import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/types.ts";
import { ConfigArguments } from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/base/config.ts";
import { Params as DduUiFFParams } from "/data/vim/repos/github.com/Shougo/ddu-ui-ff/denops/@ddu-uis/ff.ts";
import * as autocmd from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/autocmd/mod.ts";
import * as lambda from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/lambda/mod.ts";
import * as opt from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/option/mod.ts";
import { Denops } from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/mod.ts";

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
        previewRow: winRow + 1,
        previewHeight: 0,
      } satisfies Partial<DduUiFFParams>,
    },
  });
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
        matcher_fzf: {
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
        git_status: { defaultAction: "open" },
        git_tag: { defaultAction: "switch" },
        help: { defaultAction: "tabopen" },
        source: { defaultAction: "execute" },
        ui_select: { defaultAction: "select" },
        word: { defaultAction: "append" },
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_approximate"],
          sorters: ["sorter_distance"],
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
          converters: ["git_status_highlight"],
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

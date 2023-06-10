import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/types.ts";
import { ConfigArguments } from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/base/config.ts";
import { Params as DduUiFFParams } from "/data/vim/repos/github.com/Shougo/ddu-ui-ff/denops/@ddu-uis/ff.ts";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    const border = [".", ".", ".", ":", ":", ".", ":", ":"]
      .map((c) => [c, "DduBorder"]);
    const nvim = args.denops.meta.host === "nvim";
    args.contextBuilder.setGlobal({
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
          highlights: {},
          previewFloating: nvim,
          previewFloatingBorder: border as any, // そのうち直す
          previewFloatingZindex: 100,
          previewSplit: "vertical",
          split: "floating",
        } satisfies Partial<DduUiFFParams>,
      },
    });
    return Promise.resolve();
  }
}

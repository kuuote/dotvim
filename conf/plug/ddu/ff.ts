import { ConfigArguments } from "../../../denops/@deps/ddu.ts";
import {
  autocmd,
  Denops,
  lambda,
  mapping,
  option,
} from "../../../denops/@deps/denops_std.ts";
import { is, u } from "../../../denops/@deps/unknownutil.ts";
import { group, register } from "../../../denops/@vimrc/lib/lambda/autocmd.ts";
import { Params as DduUiFFParams } from "/data/vim/repos/github.com/Shougo/ddu-ui-ff/denops/@ddu-uis/ff.ts";
import {
  ActionFlags,
  BaseConfig,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/types.ts";

const augroup = "vimrc#ddu-ui-ff";

async function onColorScheme(args: ConfigArguments) {
  const hlbg = false;
  const highlights: DduUiFFParams["highlights"] = {};
  if (await args.denops.eval("&background ==# 'light'")) {
    if (hlbg) {
      await args.denops.cmd("hi DduEnd guibg=#e0e0ff guifg=#e0e0ff");
      await args.denops.cmd("hi DduFloat guibg=#e0e0ff guifg=#6060ff");
    } else {
      await args.denops.cmd("hi DduEnd guifg=#e0e0ff");
      await args.denops.cmd("hi DduFloat guifg=#6060ff");
    }
    await args.denops.cmd("hi DduBorder guibg=#f0f0ff guifg=#6060ff");
    await args.denops.cmd(
      "hi DduMatch ctermfg=205 ctermbg=225 guifg=#ff60c0 guibg=#ffd0ff cterm=NONE gui=NONE",
    );
    await args.denops.cmd(
      "hi DduCursorLine ctermfg=205 ctermbg=225 guifg=#ff6060 guibg=#ffe8e8 cterm=NONE gui=NONE",
    );
    highlights.floating = "DduFloat,EndOfBuffer:DduEnd";
    highlights.floatingCursorLine = "DduCursorLine";
  } else {
    await args.denops.cmd("hi def link DduMatch Search");
    highlights.floating = "Normal,DduBorder:Normal,DduMatch:Search";
  }
  args.contextBuilder.patchGlobal({
    uiParams: {
      ff: {
        highlights,
      },
    },
  });
}

async function calculateUiSize(
  denops: Denops,
): Promise<[x: number, y: number, width: number, height: number]> {
  const columns = await option.columns.get(denops);
  const lines = await option.lines.get(denops);
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
          previewWidth: Math.floor(await option.columns.get(args.denops)),
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

// patchLocalしてるnameをマッピングテーブル用の定義に直すためのテーブル
// X<ddu-ui-ff-aliases>
// L<ddu-locals>
const aliases: Record<string, string> = {
  git_diff: "file:git_diff",
  line: "file",
  mrr: "file",
  mru: "file",
  mrw: "file",
};

async function setupFileTypeAutocmd(args: ConfigArguments) {
  const { denops } = args;
  const opt: mapping.MapOptions = {
    buffer: true,
    nowait: true,
  };
  const nno: mapping.MapOptions = {
    ...opt,
    mode: ["n"],
  };
  const action = (name: string, params?: unknown) => {
    return `<Cmd>call ddu#ui#do_action('${name}'${
      params != null ? ", " + JSON.stringify(params) : ""
    })<CR>`;
  };
  const itemAction = (name: string, params: unknown = {}) => {
    return action("itemAction", { name, params });
  };
  const setupTable: Record<string, lambda.Fn> = {
    _: async () => {
      await mapping.map(denops, "<CR>", action("itemAction"), nno);
      await mapping.map(denops, "a", action("inputAction"), nno);
      await mapping.map(denops, "A", action("toggleAutoAction"), nno);
      await mapping.map(denops, "i", action("openFilterWindow"), nno);
      await mapping.map(denops, "q", action("quit"), nno);
      await mapping.map(
        denops,
        "s",
        action("toggleSelectItem") + action("cursorNext"),
        nno,
      );
    },
    git_diff: async () => {
      await mapping.map(
        denops,
        "p",
        [
          "<Cmd>let b:vimrc_view = winsaveview()<CR>",
          itemAction("applyPatch"),
          "<Cmd>call winrestview(b:vimrc_view)<CR>",
          "<Cmd>unlet b:vimrc_view<CR>",
        ].join(""),
        nno,
      );
    },
    git_status: async () => {
      await mapping.map(denops, "c", itemAction("commit"), nno);
      await mapping.map(denops, "d", itemAction("diff"), nno);
      await mapping.map(denops, "h", itemAction("add"), nno);
      await mapping.map(denops, "l", itemAction("reset"), nno);
    },
  };
  const setupFilterTable: Record<string, lambda.Fn> = {
    _: async () => {
      await mapping.map(denops, "<CR>", "<Esc>" + action("closeFilterWindow"), {
        ...opt,
        mode: ["n", "i"],
      });
    },
  };
  const ddu_ff = register(denops, async (name: unknown) => {
    await setupTable["_"]?.();
    u.assert(name, is.String);
    const names = (aliases[name] ?? name).split(/:/g);
    for (const name of names) {
      await setupTable[name]?.();
    }
  }, { args: "b:ddu_ui_name" });
  const ddu_ff_filter = register(denops, async (name: unknown) => {
    await setupFilterTable["_"]?.();
    u.assert(name, is.String);
    const names = (aliases[name] ?? name).split(/:/g);
    for (const name of names) {
      await setupFilterTable[name]?.();
    }
  }, { args: "b:ddu_ui_name" });
  await autocmd.group(denops, augroup, (helper) => {
    helper.define(
      "FileType",
      "ddu-ff",
      ddu_ff,
    );
    helper.define(
      "FileType",
      "ddu-ff-filter",
      ddu_ff_filter,
    );
  });
}

export class Config extends BaseConfig {
  async config(args: ConfigArguments) {
    // +-------------------+
    // | ASCII罫線はいいぞ |
    // +-------------------+
    const border = ["+", "-", "+", "|", "+", "-", "+", "|"]
      .map((c) => [c, "DduBorder"]);
    const nvim = args.denops.meta.host === "nvim";
    args.contextBuilder.patchGlobal({
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
          split: nvim ? "floating" : "no",
        } satisfies Partial<DduUiFFParams>,
      },
      uiOptions: {
        ff: {
          actions: {
            useKensaku: async (args) => {
              // L<dpp-lazy-kensaku_vim>
              await args.denops.call("dpp#source", "kensaku.vim");
              const sources = args.options.sources.map((s) => {
                if (is.String(s)) {
                  s = { name: s };
                }
                return {
                  ...s,
                  options: {
                    ...s.options,
                    matchers: ["matcher_kensaku"],
                    sorters: [],
                    converters: [],
                  },
                };
              });
              args.ddu.updateOptions({
                sources,
              });
              await args.denops.cmd("echomsg 'change to kensaku matcher'");
              return ActionFlags.Persist;
            },
          },
        },
      },
    });

    await autocmd.group(args.denops, augroup, (helper) => {
      helper.remove("*");
    });

    await group(args.denops, augroup, (helper) => {
      helper.define(
        "ColorScheme",
        "*",
        () => onColorScheme(args),
      );
      // floatwinのサイズをセットするやつ
      helper.define(
        "VimResized",
        "*",
        () => setUiSize(args),
        { async: true },
      );
    });
    await onColorScheme(args);
    await setUiSize(args);
    await setupFileTypeAutocmd(args);
  }
}

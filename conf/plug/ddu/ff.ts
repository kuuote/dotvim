import {
  BaseConfig,
  ConfigArguments,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/base/config.ts";
import { ActionFlags } from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/types.ts";
import * as autocmd from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/autocmd/mod.ts";
import * as option from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/option/mod.ts";
import * as lambda from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/lambda/mod.ts";
import {
  map,
  MapOptions,
} from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/mapping/mod.ts";
import { group, register } from "../../../denops/@vimrc/lib/lambda/autocmd.ts";
import { Params as DduUiFFParams } from "/data/vim/repos/github.com/Shougo/ddu-ui-ff/denops/@ddu-uis/ff.ts";
import { Denops } from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/mod.ts";
import * as u from "/data/vim/repos/github.com/lambdalisue/deno-unknownutil/mod.ts";

const augroup = "vimrc#ddu-ui-ff";

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
const aliases: Record<string, string> = {
  git_diff: "file:git_diff",
  mrr: "file",
  mru: "file",
  mrw: "file",
};

async function setupFileTypeAutocmd(args: ConfigArguments) {
  const { denops } = args;
  const opt: MapOptions = {
    buffer: true,
    nowait: true,
  };
  const nno: MapOptions = {
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
      await map(denops, "<CR>", action("itemAction"), nno);
      await map(denops, "q", action("quit"), nno);
      await map(denops, "i", action("openFilterWindow"), nno);
      await map(denops, "s", action("toggleSelectItem") + action("cursorNext"), nno);
      // await map(denops, "a", action("inputAction"), nno);
    },
    git_diff: async () => {
      await map(denops, "p", itemAction("applyPatch"), nno);
      // await map(denops, "p", async () => {
      //   const view = await fn.winsaveview(denops);
      //   await action("itemAction", { name: "applyPatch" })();
      //   await fn.winrestview(denops, view);
      // }, nno);
    },
  };
  const setupFilterTable: Record<string, lambda.Fn> = {
    _: async () => {
      await map(denops, "<CR>", "<Esc>" + action("closeFilterWindow"), {
        ...opt,
        mode: ["n", "i"],
      });
    },
  };
  const ddu_ff = register(denops, async (name: unknown) => {
    await setupTable["_"]?.();
    u.assert(name, u.isString);
    const names = (aliases[name] ?? name).split(/:/g);
    for (const name of names) {
      await setupTable[name]?.();
    }
  }, { args: "b:ddu_ui_name" });
  const ddu_ff_filter = register(denops, async (name: unknown) => {
    await setupFilterTable["_"]?.();
    u.assert(name, u.isString);
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
          split: args.denops.meta.host == "nvim" ? "floating" : "horizontal",
        } satisfies Partial<DduUiFFParams>,
      },
      uiOptions: {
        ff: {
          actions: {
            useKensaku: async (args) => {
              // L<dpp-lazy-kensaku_vim>
              await args.denops.call("dpp#source", "kensaku.vim");
              const sources = args.options.sources.map((s) => {
                if (u.isString(s)) {
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

    // floatwinのサイズをセットするやつ
    await group(args.denops, augroup, (helper) => {
      helper.define(
        "VimResized",
        "*",
        () => setUiSize(args),
        { async: true },
      );
    });
    await setUiSize(args);
    await setupFileTypeAutocmd(args);
  }
}

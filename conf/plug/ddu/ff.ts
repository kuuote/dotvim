import {
  BaseConfig,
  ConfigArguments,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/base/config.ts";
import { ActionFlags } from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/types.ts";
import * as autocmd from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/autocmd/mod.ts";
import * as lambda from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/lambda/mod.ts";
import * as option from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/option/mod.ts";
import { generateDenopsCall } from "../../../denops/@vimrc/lib/denops.ts";

const augroup = "ddu-ui-ff#" + performance.now();

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

export class Config extends BaseConfig {
  async config(args: ConfigArguments) {
    await autocmd.group(args.denops, augroup, (helper) => {
      helper.remove("*");
    });
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
              // L<dein-lazy-kensaku_vim>
              await args.denops.call("dein#source", "kensaku.vim");
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
    // floatwinのサイズをセットするやつ
    const id = lambda.register(args.denops, () => setUiSize(args));
    await autocmd.group(args.denops, augroup, (helper) => {
      helper.define(
        "VimResized",
        "*",
        generateDenopsCall(args.denops, id, "[]", { async: true }),
      );
    });
    await setUiSize(args);
  }
}

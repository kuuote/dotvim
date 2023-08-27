import { Params as DduUiFFParams } from "../../../deno/ddu-ui-ff/denops/@ddu-uis/ff.ts";
import {
  BaseConfig,
  ConfigArguments,
} from "../../../deno/ddu.vim/denops/ddu/base/config.ts";
import { ActionFlags } from "../../../deno/ddu.vim/denops/ddu/types.ts";
import * as autocmd from "../../../deno/denops_std/denops_std/autocmd/mod.ts";
import * as fn from "../../../deno/denops_std/denops_std/function/mod.ts";
import * as lambda from "../../../deno/denops_std/denops_std/lambda/mod.ts";
import * as mapping from "../../../deno/denops_std/denops_std/mapping/mod.ts";
import { Denops } from "../../../deno/denops_std/denops_std/mod.ts";
import * as opt from "../../../deno/denops_std/denops_std/option/mod.ts";
import * as u from "../../../deno/unknownutil/mod.ts";
import { generateDenopsRequest } from "../../../denops/@vimrc/denopscall.ts";
import { map } from "../../../denops/@vimrc/lambda.ts";
import { dduHelper } from "./lib/helper.ts";

type Never = Record<PropertyKey, never>;

const augroup = "vimrc.ddu.ui.ff";

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

// side Vim

// patchLocalしてるnameをマッピングテーブル用の定義に直すためのテーブル
const aliases: Record<string, string> = {
  git_diff: "file:git_diff",
};

async function setupFileTypeAutocmd(args: ConfigArguments) {
  /* helper共 */

  const denops = args.denops;
  const ddu = dduHelper(denops);

  const action = (name: string, params: Record<string, unknown> = {}) => () =>
    ddu.uiSyncAction(name, params);

  const opts = {
    buffer: true,
    noremap: true,
    nowait: true,
  } as mapping.MapOptions;

  const nno = {
    ...opts,
    mode: ["n"],
  } as mapping.MapOptions;

  /* ここから実際の定義
   * X<ddu-ui-ff-mappings>
   */

  const setupTable: Record<string, lambda.Fn> = {
    _: async () => {
      await map(denops, "a", action("inputAction"), nno);
      await map(denops, "<CR>", action("itemAction"), nno);
      await map(denops, "<Tab>", async () => {
        await action("toggleSelectItem")();
        await action("cursorNext")();
      }, nno);
    },
    git_diff: async () => {
      await map(denops, "p", async () => {
        const view = await fn.winsaveview(denops);
        await action("itemAction", { name: "applyPatch" })();
        await fn.winrestview(denops, view);
      }, nno);
    },
  };
  const setupFilterTable: Record<string, lambda.Fn> = {
    _: async () => {
      await map(denops, "<CR>", async () => {
        await denops.cmd("stopinsert");
        await ddu.uiSyncAction("closeFilterWindow");
      }, {
        ...opts,
        mode: ["n", "i"],
      });
    },
  };
  const ddu_ff = lambda.register(denops, async (name: unknown) => {
    await setupTable["_"]?.();
    u.assert(name, u.isString);
    const names = (aliases[name] ?? name).split(/:/g);
    for (const name of names) {
      await setupTable[name]?.();
    }
  });
  const ddu_ff_filter = lambda.register(denops, async (name: unknown) => {
    await setupFilterTable["_"]?.();
    u.assert(name, u.isString);
    const names = (aliases[name] ?? name).split(/:/g);
    for (const name of names) {
      await setupFilterTable[name]?.();
    }
  });
  await autocmd.group(denops, augroup, (helper) => {
    // configの方で消してるのでこっちではしない
    helper.define(
      "FileType",
      "ddu-ff",
      "call " + generateDenopsRequest(denops, ddu_ff, "[b:ddu_ui_name]"),
    );
    helper.define(
      "FileType",
      "ddu-ff-filter",
      "call " + generateDenopsRequest(denops, ddu_ff_filter, "[b:ddu_ui_name]"),
    );
  });
}

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    // border idea by @eetann
    // const border = [".", ".", ".", ":", ":", ".", ":", ":"]
    //   .map((c) => [c, "DduBorder"]);

    // +-------------------+
    // | ASCII罫線はいいぞ |
    // +-------------------+
    const border = ["+", "-", "+", "|", "+", "-", "+", "|"]
      .map((c) => [c, "DduBorder"]);
    const nvim = args.denops.meta.host === "nvim";
    args.contextBuilder.patchGlobal({
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
      helper.remove("*");
      helper.define(
        "VimResized",
        "*",
        `call denops#notify('ddu', '${id}', [])`,
      );
    });
    await setUiSize(args);
    await setupFileTypeAutocmd(args);
  }
}

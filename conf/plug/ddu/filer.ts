import { register } from "../../../denops/@vimrc/lib/lambda/autocmd.ts";
import { BaseConfig, ConfigArguments, DduItem } from "/data/vim/deps/ddu.ts";
import { autocmd, lambda, mapping } from "/data/vim/deps/denops_std.ts";
import { is, u } from "/data/vim/deps/unknownutil.ts";

const augroup = "vimrc#ddu-ui-filer";

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
      await mapping.map(denops, "d", itemAction("narrow", { path: ".." }), nno);
      await mapping.map(denops, "h", action("fernCollapse"), nno);
      await mapping.map(denops, "l", action("fernExpandOrItemAction"), nno);
      await mapping.map(denops, "q", action("quit"), nno);
      await mapping.map(
        denops,
        "s",
        action("toggleSelectItem") + action("cursorNext"),
        nno,
      );
    },
  };
  const ddu_filer = register(denops, async (name: unknown) => {
    await setupTable["_"]?.();
    u.assert(name, is.String);
    // const names = (aliases[name] ?? name).split(/:/g);
    // for (const name of names) {
    //   await setupTable[name]?.();
    // }
  }, { args: "b:ddu_ui_name" });
  await autocmd.group(denops, augroup, (helper) => {
    helper.define(
      "FileType",
      "ddu-filer",
      ddu_filer,
    );
  });
}
export class Config extends BaseConfig {
  async config(args: ConfigArguments) {
    const nvim = args.denops.meta.host === "nvim";
    args.contextBuilder.patchGlobal({
      uiOptions: {
        filer: {
          actions: {
            fernCollapse: async () => {
              const curPos = Number(await args.denops.call("line", ".")) - 1;
              const items = await args.denops.call(
                "ddu#ui#get_items",
              ) as DduItem[];
              for (let pos = curPos; pos >= 0; pos--) {
                if (items[pos].isTree && items[pos].__expanded) {
                  await args.denops.call("ddu#ui#do_action", "cursorPrevious", {
                    count: curPos - pos,
                  });
                  await args.denops.call("ddu#ui#do_action", "collapseItem");
                  return;
                }
              }
            },
            fernExpandOrItemAction: async () => {
              const item = await args.denops.call("ddu#ui#get_item") as DduItem;
              if (item.isTree) {
                const oldLines = await args.denops.call("line", "$");
                await args.denops.call("ddu#ui#do_action", "expandItem");
                const newLines = await args.denops.call("line", "$");
                if (oldLines != newLines) {
                  // なんか展開されてたらカーソル動かす
                  await args.denops.call("ddu#ui#do_action", "cursorNext");
                }
              } else {
                await args.denops.call("ddu#ui#do_action", "itemAction");
              }
            },
          },
        },
      },
      uiParams: {
        filer: {
          split: nvim ? "floating" : "horizontal",
          sort: "filename",
          sortTreesFirst: true,
        },
      },
    });
    await setupFileTypeAutocmd(args);
  }
}

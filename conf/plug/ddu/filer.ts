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
    const paramsStr = params == null ? "" : ", " +
      JSON.stringify(params, (_, v) => is.Boolean(v) ? "__ddu__" + v : v)
        .replaceAll(/"__ddu__(\w+)"/g, "v:$1");
    return `<Cmd>call ddu#ui#do_action('${name}'${paramsStr})<CR>`;
  };
  const itemAction = (name: string, params: unknown = {}) => {
    return action("itemAction", { name, params });
  };
  const setupTable: Record<string, lambda.Fn> = {
    _: async () => {
      await mapping.map(denops, "<CR>", action("itemAction"), nno);
      await mapping.map(denops, "d", itemAction("narrow", { path: ".." }), nno);
      await mapping.map(denops, "h", action("collapseItem"), nno);
      await mapping.map(
        denops,
        "l",
        action("expandItem", { isInTree: true }),
        nno,
      );
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

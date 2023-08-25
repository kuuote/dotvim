import {
  BaseConfig,
  ConfigArguments,
} from "../../../deno/ddc.vim/denops/ddc/base/config.ts";
import { DdcOptions } from "../../../deno/ddc.vim/denops/ddc/types.ts";
import * as autocmd from "../../../deno/denops_std/denops_std/autocmd/mod.ts";
import * as mapping from "../../../deno/denops_std/denops_std/mapping/mod.ts";
import { Denops } from "../../../deno/denops_std/denops_std/mod.ts";
import * as option from "../../../deno/denops_std/denops_std/option/mod.ts";
import * as u from "../../../deno/unknownutil/mod.ts";
import { Params as BufParams } from "../../../denops/@ddc-sources/buf.ts";
import { Params as ListParams } from "../../../denops/@ddc-sources/list.ts";
import { map } from "../../../denops/@vimrc/lambda.ts";

/*
X<ddc-config-manual_complete>
欲しい機能
  Cを押すと補完ソース選びの補完ソースに切り替わり、マニュアル補完が走る
    確定すると一時的にソースが切り替わりマニュアル補完が走る
  Lを押すとマニュアル補完
  Rを押すかノーマルモードに抜けると解除
    ノーマルモード抜けは未来の課題とする
    意外と面倒なのを忘れていた
*/

async function echomsg(denops: Denops, msg: string) {
  await denops.cmd("echomsg msg", { msg }).catch(console.log);
}
const configSet: Record<
  string,
  (denops: Denops) => Promise<Partial<DdcOptions>>
> = {
  "buf:filetype": () =>
    Promise.resolve({
      sources: [{
        name: "buf",
        params: {
          finder: async (denops) => {
            const bufnrs = await denops.eval(
              `getbufinfo()->filter('v:val.bufnr != bufnr() && !empty(v:val.windows) && getbufvar(v:val.bufnr, "&filetype") ==# &l:filetype')->map('v:val.bufnr')`,
            );
            return u.ensure(bufnrs, u.isArrayOf(u.isNumber));
          },
        } satisfies BufParams,
      }],
    }),
  file: () =>
    Promise.resolve({
      sources: ["file"],
    }),
  lspoints: () =>
    Promise.resolve({
      sources: [{
        name: "lspoints",
        options: {
          minAutoCompleteLength: 1,
        },
      }],
    }),
  snippet: () =>
    Promise.resolve({
      sources: ["tsnip", "vsnip"],
    }),
};

const saveConfig: Record<number, Partial<DdcOptions>> = {};

function restoreConfig(args: ConfigArguments) {
  const config = args.contextBuilder.getBuffer();
  for (const _bufnr of Object.keys(saveConfig)) {
    const bufnr = Number(_bufnr);
    const saved = saveConfig[bufnr];
    if (saved == null) {
      delete config[bufnr];
    } else {
      config[bufnr] = saved;
    }
    delete saveConfig[bufnr];
  }
}

async function setConfig(args: ConfigArguments, name: string) {
  const bufnr = Number(await args.denops.call("bufnr"));
  const gconfig = args.contextBuilder.getBuffer();
  const config = gconfig[bufnr];
  if (saveConfig[bufnr] == null) {
    saveConfig[bufnr] = config;
  }
  const set = configSet[name];
  if (set == null) {
    restoreConfig(args);
    return;
  }
  args.contextBuilder.setBuffer(bufnr, await set(args.denops));
  args.contextBuilder.patchBuffer(bufnr, {
    specialBufferCompletion: true,
  });
  await args.denops.call("ddc#map#manual_complete");
}

const configMap: Record<string, string> = {};

// configSetを指定させてマッピングする
async function inputConfigSet(args: ConfigArguments) {
  const bufnr = Number(await args.denops.call("bufnr"));
  const gconfig = args.contextBuilder.getBuffer();
  const config = gconfig[bufnr];
  args.contextBuilder.setBuffer(bufnr, {
    cmdlineSources: [{
      name: "list",
      options: {
        minAutoCompleteLength: 0,
      },
      params: {
        candidates: Object.keys(configSet),
      } satisfies ListParams,
    }],
    specialBufferCompletion: true,
  });
  const ve = await option.virtualedit.getLocal(args.denops);
  try {
    // 末尾にカーソルあるとinput後に動くんで上書き
    await option.virtualedit.setLocal(args.denops, "onemore");
    await autocmd.define(
      args.denops,
      "CmdlineEnter",
      "*",
      "call ddc#map#manual_complete()",
      {
        once: true,
      },
    );
    await args.denops.call("ddc#hide");
    const name = String(await args.denops.call("input", "name?"));
    await args.denops.call("ddc#map#manual_complete", { ui: "none" });
    args.contextBuilder.setBuffer(bufnr, { ui: "none" });
    const key = String(await args.denops.call("input", "key?"));
    if (configSet[name] == null) {
      delete configMap[key];
    } else {
      configMap[key] = name;
    }
  } catch (e) {
    console.log(e);
  } finally {
    await option.virtualedit.setLocal(args.denops, ve);
    if (config == null) {
      delete gconfig[bufnr];
    } else {
      gconfig[bufnr] = config;
    }
  }
}

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const ino: mapping.MapOptions = {
      mode: "i",
      noremap: true,
      nowait: true,
    };
    // XXでconfig指定、X{key}で使えるようにする
    await map(args.denops, "X", async () => {
      const key = String(await args.denops.call("getcharstr"));
      if (key == "X") {
        await inputConfigSet(args);
      }
      const name = configMap[key];
      if (name != null) {
        await setConfig(args, name);
        await echomsg(args.denops, `set to ${name}`);
      }
    }, ino);
    await map(args.denops, "L", async () => {
      await args.denops.call("ddc#map#manual_complete");
    }, ino);
    await map(args.denops, "R", async () => {
      await args.denops.call("ddc#hide");
      restoreConfig(args);
      await echomsg(args.denops, "restore buffer config");
    }, ino);
  }
}

// import { Params as BufParams } from "../../../denops/@ddc-sources/buf.ts";
import {
  BaseConfig,
  ConfigArguments,
  DdcOptions,
} from "../../../denops/deps/ddc.ts";
import { Denops, mapping, option } from "../../../denops/deps/denops_std.ts";
import { map } from "../../../denops/@vimrc/lib/lambda/map.ts";
import { Params as ListParams } from "../../../denops/@ddc-sources/list.ts";

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
  //  "buf:filetype": () =>
  //    Promise.resolve({
  //      sources: [{
  //        name: "buf",
  //        params: {
  //          finder: async (denops) => {
  //            const bufnrs = await denops.eval(
  //              `getbufinfo()->filter('v:val.bufnr != bufnr() && !empty(v:val.windows) && getbufvar(v:val.bufnr, "&filetype") ==# &l:filetype')->map('v:val.bufnr')`,
  //            );
  //            return u.ensure(bufnrs, u.isArrayOf(u.isNumber));
  //          },
  //        } satisfies BufParams,
  //      }],
  //    }),
  file: () =>
    Promise.resolve({
      sources: ["file"],
    }),
  lsp: async (denops) => {
    const lspEngine = String(
      await denops.eval(
        "get(b:, 'ddu_source_lsp_clientName', get(g:, 'ddu_source_lsp_clientName', 'nvim-lsp'))",
      ),
    );
    return {
      sources: [{
        name: "lsp",
        options: {
          minAutoCompleteLength: 1,
        },
        params: {
          lspEngine,
        },
      }],
    };
  },

  snippet: async (denops) => {
    await denops.call("dpp#source", "denippet.vim");
    return {
      sources: ["denippet"],
    };
  },
};

async function setConfig(args: ConfigArguments, name: string) {
  const bufnr = Number(await args.denops.call("bufnr"));
  const set = configSet[name];
  if (set == null) {
    await resetConfig(args);
    return;
  }
  args.contextBuilder.setBuffer(bufnr, await set(args.denops));
  args.contextBuilder.patchBuffer(bufnr, {
    specialBufferCompletion: true,
  });
  await args.denops.call("ddc#map#manual_complete");
}

async function resetConfig(args: ConfigArguments) {
  const config = args.contextBuilder.getBuffer();
  for (const _bufnr of Object.keys(config)) {
    const bufnr = Number(_bufnr);
    delete config[bufnr];
  }
  await args.denops.call("ddc#hide");
}

const configMap: Record<string, string> = {
  F: "file",
  S: "lsp",
  T: "snippet",
};

// configSetを指定させてマッピングする
async function inputConfigSet(args: ConfigArguments) {
  const bufnr = Number(await args.denops.call("bufnr"));
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
    const name = String(await args.denops.call("input", "name?"));
    args.contextBuilder.setBuffer(bufnr, { ui: "none" });
    const key = String(await args.denops.call("input", "key?"));
    if (configSet[name] == null) {
      delete configMap[key];
      await resetConfig(args);
    } else {
      configMap[key] = name;
      await setConfig(args, key);
    }
  } catch (e) {
    console.log(e);
    await resetConfig(args);
  } finally {
    await option.virtualedit.setLocal(args.denops, ve);
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
      await resetConfig(args);
      await echomsg(args.denops, "restore buffer config");
    }, ino);
  }
}

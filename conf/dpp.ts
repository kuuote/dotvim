import {
  ensure,
  is,
} from "/data/vim/repos/github.com/lambdalisue/deno-unknownutil/mod.ts";
import {
  BaseConfig,
  ConfigReturn,
} from "/data/vim/repos/github.com/Shougo/dpp.vim/denops/dpp/base/config.ts";
import { Denops } from "/data/vim/repos/github.com/Shougo/dpp.vim/denops/dpp/deps.ts";
import {
  ContextBuilder,
  Dpp,
  Plugin,
} from "/data/vim/repos/github.com/Shougo/dpp.vim/denops/dpp/types.ts";

type Toml = {
  plugins: Plugin[];
};

type LazyMakeStateResult = {
  plugins: Plugin[];
  stateLines: string[];
};

const isStringArray = is.ArrayOf(is.String);

async function glob(denops: Denops, path: string): Promise<string[]> {
  return ensure(
    await denops.call("glob", path, 1, 1),
    isStringArray,
  );
}

export class Config extends BaseConfig {
  override async config(args: {
    contextBuilder: ContextBuilder;
    denops: Denops;
    basePath: string;
    dpp: Dpp;
  }): Promise<ConfigReturn> {
    const vim = args.denops.meta.host === "vim";
    const nvim = args.denops.meta.host === "nvim";
    // X<dpp-inline_vimrcs>
    const inlineVimrcs = [
      await glob(args.denops, "$VIMDIR/conf/rc/*"),
      await glob(args.denops, "$VIMDIR/local/rc/*"),
      vim ? await glob(args.denops, "$VIMDIR/conf/rc/vim/*") : [],
      nvim ? await glob(args.denops, "$VIMDIR/conf/rc/nvim/*") : [],
    ].flat()
      .filter((path) => path.match(/\.(?:vim|lua)$/));

    args.contextBuilder.setGlobal({
      inlineVimrcs,
      protocols: ["git"],
    });

    const [context, options] = await args.contextBuilder.get(args.denops);
    const plugins: Plugin[] = [];

    const profiles = new Set<string>();

    profiles.add("colorscheme");
    profiles.add("ddc");
    profiles.add("ddu");
    profiles.add("dpp");
    profiles.add("filetype_vim");
    profiles.add("lspoints");
    profiles.add("main");
    profiles.add("treesitter");

    const tomls = await glob(args.denops, "$VIMDIR/conf/plug/**/*.toml");
    for (const tomlPath of tomls) {
      console.log("load toml: " + tomlPath);
      const toml = await args.dpp.extAction(
        args.denops,
        context,
        options,
        "toml",
        "load",
        {
          path: tomlPath,
        },
      ) as Toml;

      const profileVim = tomlPath.match(/\/vim\//) != null;
      const profileNvim = tomlPath.match(/\/nvim\//) != null;
      const profileIgnore = (profileVim && nvim) || (profileNvim && vim);

      const profile = tomlPath.match(/([^/]+)\.toml$/)?.[1];
      if (profileIgnore || !profiles.has(profile!)) {
        for (const p of toml.plugins) {
          // プロフィール対象外を無効化してみる
          p.if = false;
        }
      }
      plugins.push(...toml.plugins);
    }
    for (let i = 0; i < plugins.length; i++) {
      const p = plugins[i];
      // 無効化したプラギンの情報を消しておく
      if ("if" in p) {
        if (is.String(p.if)) {
          p.if = Boolean(await args.denops.eval(p.if));
        }
        if (!p.if) {
          plugins[i] = {
            name: p.name,
            repo: p.repo,
            if: false,
          };
        }
      }
      // adhoc local
      if (p.repo?.includes("$")) {
        p.repo = String(await args.denops.call("expand", p.repo));
      }
      if (p.repo?.[0] === "/") {
        p.path = p.repo;
      }
    }
    const lazyResult = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins,
      },
    ) as LazyMakeStateResult;

    // プラギン置き場として/data/vimを使う
    const repos = args.basePath + "/repos";
    await Deno.remove(repos, { recursive: true }).catch(console.trace);
    await Deno.mkdir(args.basePath, { recursive: true });
    await Deno.symlink("/data/vim/repos", repos);

    return {
      plugins: lazyResult.plugins,
      stateLines: [
        lazyResult.stateLines,
      ].flat(),
    };
  }
}

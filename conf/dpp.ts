import { ensure, is } from "jsr:@core/unknownutil";
import { Denops } from "jsr:@denops/std";
import {
  Ext as LazyExt,
  LazyMakeStateResult,
  Params as LazyParams,
} from "jsr:@shougo/dpp-ext-lazy";
import { Ext as TomlExt, Params as TomlParams } from "jsr:@shougo/dpp-ext-toml";
import {
  BaseConfig,
  ConfigArguments,
  ConfigReturn,
} from "jsr:@shougo/dpp-vim/config";
import { Protocol } from "jsr:@shougo/dpp-vim/protocol";
import { ExtOptions, Plugin } from "jsr:@shougo/dpp-vim/types";

type Toml = {
  plugins: Plugin[];
};

const isStringArray = is.ArrayOf(is.String);

async function glob(denops: Denops, path: string): Promise<string[]> {
  return ensure(
    await denops.call("glob", path, 1, 1),
    isStringArray,
  );
}

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const vim = args.denops.meta.host === "vim";
    const nvim = args.denops.meta.host === "nvim";
    // X<dpp-inline_vimrcs>
    const inlineVimrcs = [
      await glob(args.denops, "$MYVIMDIR/conf/rc/*"),
      await glob(args.denops, "$MYVIMDIR/local/rc/*"),
      vim ? await glob(args.denops, "$MYVIMDIR/conf/rc/vim/*") : [],
      nvim ? await glob(args.denops, "$MYVIMDIR/conf/rc/nvim/*") : [],
    ].flat()
      .filter((path) => path.match(/\.(?:vim|lua)$/));

    args.contextBuilder.setGlobal({
      inlineVimrcs,
      protocols: ["git"],
    });

    const [context, options] = await args.contextBuilder.get(args.denops);
    const protocols = await args.denops.dispatcher.getProtocols() as Record<
      string,
      Protocol
    >;
    const plugins: Plugin[] = [];

    const profiles = new Set<string>();

    profiles.add("colorscheme");
    profiles.add("ddc");
    profiles.add("ddt");
    profiles.add("ddu");
    profiles.add("dpp");
    profiles.add("filetype_help");
    profiles.add("filetype_vim");
    profiles.add("main");
    profiles.add("telescope");
    profiles.add("treesitter");
    profiles.add("x"); // 実験的に入れたいプラギン

    // LSP
    // profiles.add("coc");
    profiles.add("lspoints");
    profiles.add("nvim_lsp");
    // profiles.add("vim_lsp");

    const [tomlExt, tomlOptions, tomlParams]: [
      TomlExt | undefined,
      ExtOptions,
      TomlParams,
    ] = await args.denops.dispatcher.getExt(
      "toml",
    ) as [TomlExt | undefined, ExtOptions, TomlParams];
    const tomls = await glob(args.denops, "$MYVIMDIR/conf/plug/**/*.toml");
    for (const tomlPath of tomls) {
      const toml = await tomlExt!.actions.load.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: tomlOptions,
        extParams: tomlParams,
        actionParams: {
          path: tomlPath,
        },
      }) as Toml;

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
            rev: p.rev,
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

    const [lazyExt, lazyOptions, lazyParams]: [
      LazyExt | undefined,
      ExtOptions,
      LazyParams,
    ] = await args.denops.dispatcher.getExt(
      "lazy",
    ) as [LazyExt | undefined, ExtOptions, LazyParams];
    const lazyResult = await lazyExt!.actions.makeState.callback({
      denops: args.denops,
      context,
      options,
      protocols,
      extOptions: lazyOptions,
      extParams: lazyParams,
      actionParams: {
        plugins,
      },
    }) as LazyMakeStateResult;

    // プラギン置き場として/data/vimを使う
    const repos = args.basePath + "/repos";
    await Deno.remove(repos, { recursive: true }).catch(() => {});
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

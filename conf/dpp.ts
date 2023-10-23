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

export class Config extends BaseConfig {
  override async config(args: {
    contextBuilder: ContextBuilder;
    denops: Denops;
    basePath: string;
    dpp: Dpp;
  }): Promise<ConfigReturn> {
    // X<dpp-inline_vimrcs>
    const inlineVimrcs = [];
    inlineVimrcs.push(
      ...await args.denops.call(
        "glob",
        "$VIMDIR/conf/rc/*.vim",
        1,
        1,
      ) as string[],
    );
    inlineVimrcs.push(
      ...await args.denops.call(
        "glob",
        "$VIMDIR/local/rc/*.vim",
        1,
        1,
      ) as string[],
    );

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

    const tomls = ensure(
      await args.denops.call("glob", "$VIMDIR/conf/plug/**/*.toml", 1, 1),
      is.ArrayOf(is.String),
    );
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

      const host = args.denops.meta.host;
      const profileVim = tomlPath.match(/\/vim\//) != null;
      const profileNvim = tomlPath.match(/\/nvim\//) != null;
      const profileIgnore = (profileVim && host != "vim") ||
        (profileNvim && host != "nvim");

      const profile = tomlPath.match(/([^/]+)\.toml$/)?.[1];
      if (profileIgnore || !profiles.has(profile!)) {
        for (let i = 0; i < toml.plugins.length; i++) {
          // プロフィール対象外を雑に無効化してみる
          const old = toml.plugins[i];
          toml.plugins[i] = {
            name: old.name,
            repo: old.repo,
            if: false,
            // 今の所if効かないのでrtp書き換えておく
            rtp: "null",
          };
        }
      }
      plugins.push(...toml.plugins);
    }
    for (const p of plugins) {
      // adhoc local
      if (p.repo?.includes("$")) {
        p.repo = String(await args.denops.call("expand", p.repo));
      }
      if (p.repo?.[0] === "/") {
        p.path = p.repo;
      }
      // adhoc on_cmd
      if (p.on_cmd != null) {
        if (typeof p.on_cmd === "string") {
          p.on_cmd = [p.on_cmd];
        }
        const commands = p.on_cmd.map((cmd) =>
          `command! -bang -nargs=* ${cmd} delcommand ${cmd} | call dpp#source('${p.name}') | ${cmd}<bang> <args>`
        );
        p.hook_add = commands.join("\n") + "\n" + (p.hook_add ?? "");
        delete p.on_cmd;
        p.lazy = true;
      }
    }
    const lazyStateLines = ensure(
      await args.dpp.extAction(
        args.denops,
        context,
        options,
        "lazy",
        "makeState",
        {
          plugins,
        },
      ),
      is.ArrayOf(is.String),
    );

    // プラギン置き場として/data/vimを使う
    const repos = args.basePath + "/repos";
    await Deno.remove(repos, { recursive: true }).catch(console.trace);
    await Deno.mkdir(args.basePath, { recursive: true });
    await Deno.symlink("/data/vim/repos", repos);

    return {
      plugins,
      stateLines: [
        lazyStateLines,
      ].flat(),
    };
  }
}

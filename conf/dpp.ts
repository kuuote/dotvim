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
    let plugins: Plugin[] = [{
      name: "dpp.vim",
      repo: "Shougo/dpp.vim",
    }];
    const tomls = ensure(
      await args.denops.call("glob", "$VIMDIR/conf/plug/**/*.toml", 1, 1),
      is.ArrayOf(is.String),
    );
    for (const toml of tomls) {
      plugins = plugins.concat(
        (await args.dpp.extAction(
          args.denops,
          context,
          options,
          "toml",
          "load",
          {
            path: toml,
          },
        ) as Toml).plugins,
      );
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
          `command! -nargs=* ${cmd} delcommand ${cmd} | call dpp#source('${p.name}') | ${cmd} <args>`
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

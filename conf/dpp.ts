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

type MyPlugin = Plugin & {
  hook_add?: string;
};

export class Config extends BaseConfig {
  override async config(args: {
    contextBuilder: ContextBuilder;
    denops: Denops;
    basePath: string;
    dpp: Dpp;
  }): Promise<ConfigReturn> {
    const [context, options] = await args.contextBuilder.get(args.denops);
    let plugins: MyPlugin[] = [{
      name: "dpp.vim",
      repo: "Shougo/dpp.vim",
    }];
    const tomls = ensure(
      await args.denops.call("glob", "$VIMDIR/conf/plug/**/*.toml", 1, 1),
      is.ArrayOf(is.String),
    );
    for (const toml of tomls) {
      plugins = plugins.concat(
        await args.dpp.extAction(
          args.denops,
          context,
          options,
          "toml",
          "load",
          {
            path: toml,
          },
        ) as MyPlugin[],
      );
    }
    const hookAdds = [];
    for (const p of plugins) {
      // adhoc github
      if (p.repo?.match(/^[^/]+\/[^/]+$/)) {
        p.repo = "https://github.com/" + p.repo;
      }
      // adhoc plugin base path for URL
      if (p.repo?.match(/^https:\/\//)) {
        p.path = "/data/vim/repos/" + p.repo.replace(/^https:\/\//, "");
      }
      if (p.repo?.[0] === "/") {
        p.path = p.repo;
      }
      // recache実装されるまでmerge切っておく必要がありそう
      p.local = true;
      // adhoc hook_add
      if (p.hook_add != null) {
        hookAdds.push(...p.hook_add.split(/\n/));
      }
    }
    return {
      plugins,
      stateLines: hookAdds,
    };
  }
}

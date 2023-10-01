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
    const [_, options] = await args.contextBuilder.get(args.denops);
    let plugins: MyPlugin[] = [{
      name: "dpp.vim",
      repo: "Shougo/dpp.vim",
    }];
    plugins = plugins.concat(
      await args.dpp.extAction(args.denops, options, "toml", "load", {
        path: "$VIMDIR/conf/plug/ddc.toml",
      }) as MyPlugin[],
    );
    plugins = plugins.concat(
      await args.dpp.extAction(args.denops, options, "toml", "load", {
        path: "$VIMDIR/conf/plug/ddu.toml",
      }) as MyPlugin[],
    );
    plugins = plugins.concat(
      await args.dpp.extAction(args.denops, options, "toml", "load", {
        path: "$VIMDIR/conf/plug/main.toml",
      }) as MyPlugin[],
    );
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
      if (p.repo?.[0] === '/') {
        p.path = p.repo;
      }
      // recache実装されるまでmerge切っておく必要がありそう
      p.local = true;
      // adhoc hook_add
      if (p.hook_add != null) {
        hookAdds.push(...p.hook_add.split(/\n/));
      }
    }
    console.log("yeah");
    console.log(hookAdds);
    return {
      plugins,
      stateLines: hookAdds,
    };
  }
}

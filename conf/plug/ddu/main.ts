import {
  BaseConfig,
  ConfigArguments,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/base/config.ts";
import {
  ActionFlags,
  DduOptions,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/types.ts";

function setupLocals(args: ConfigArguments) {
  // X<ddu-local-source-mr>
  for (const type of ["mru", "mrw", "mrr"]) {
    args.contextBuilder.patchLocal(type, {
      sources: [{
        name: "mr",
        params: {
          kind: type,
        },
      }],
    });
  }
}

export class Config extends BaseConfig {
  async config(args: ConfigArguments) {
    // default options
    const defaultMatchers = ["matcher_fzf"];
    const defaultSorters = ["sorter_fzf"];
    // X<ddu-global>
    args.contextBuilder.patchGlobal({
      kindOptions: {
        // X<ddu-kind-file>
        file: {
          defaultAction: "open",
        },
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: defaultMatchers,
          sorters: defaultSorters,
        },
      },
    });

    await setupLocals(args);
  }
}

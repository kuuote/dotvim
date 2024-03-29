import * as sourceList from "../../../denops/@ddu-sources/list.ts";
import { KindGitStatusActionData } from "../../../denops/@deps/ddu-kinds.ts";
import {
  ActionFlags,
  BaseConfig,
  ConfigArguments,
  DduOptions,
} from "../../../denops/@deps/ddu.ts";
import { stdpath } from "../../../denops/@deps/deno_std.ts";
import { autocmd, Denops } from "../../../denops/@deps/denops_std.ts";
import { is, u } from "../../../denops/@deps/unknownutil.ts";
import { cmd, map } from "../../../denops/@vimrc/lib/lambda/map.ts";
import { dduHelper } from "./lib/helper.ts";

/* main section */

type Filters = {
  matchers: string[];
  sorters: string[];
  converters: string[];
};

const Filters: Record<string, Filters> = {
  fzf: {
    matchers: ["matcher_fzf"],
    sorters: ["sorter_fzf"],
    converters: [],
  },
  fzf_random_first: {
    matchers: ["matcher_fzf"],
    sorters: ["random_first", "sorter_fzf"],
    converters: [],
  },
  live_grep: {
    matchers: [],
    sorters: ["sorter_alpha_path"],
    converters: [],
  },
  mtime_substring: {
    matchers: ["matcher_substring"],
    sorters: ["sorter_mtime"],
    converters: [],
  },
};

const FiltersLocal: Record<string, Filters> = {
  file_hl_dir: {
    ...Filters.fzf,
    converters: ["converter_hl_dir"],
  },
  git_status: {
    ...Filters.fzf,
    converters: [
      "converter_hl_dir",
      "converter_git_status",
    ],
  },
};

function setupGitStatus(args: ConfigArguments) {
  const ddu = dduHelper(args.denops);
  args.contextBuilder.patchGlobal({
    kindOptions: {
      git_status: {
        actions: {
          commit: async () => {
            await args.denops.call("funnygit#commit");
            // await args.denops.cmd("Gin commit");
            return ActionFlags.None;
          },
          diff: (args) => {
            const action = args.items[0].action as KindGitStatusActionData;
            const path = stdpath.join(action.worktree, action.path);
            ddu.start({
              name: "git_diff",
              sources: [{
                name: "git_diff",
                options: {
                  path,
                },
                params: {
                  unifiedContext: 0,
                  ...u.maybe(args.actionParams, is.Record) ?? {},
                  onlyFile: true,
                },
              }],
            });
            return Promise.resolve(ActionFlags.None);
          },
          patch: async (args) => {
            for (const item of args.items) {
              const action = item.action as KindGitStatusActionData;
              await args.denops.cmd("tabnew");
              await args.denops.cmd("tcd " + action.worktree);
              await args.denops.cmd("GinPatch ++no-head " + action.path);
            }
            return ActionFlags.None;
          },
        },
        defaultAction: "open",
      },
    },
    sourceOptions: {
      // X<ddu-source-git_status>
      git_status: {
        ...FiltersLocal.git_status,
      },
    },
  });
  args.contextBuilder.patchLocal("git_status", {
    actionOptions: {
      add: { quit: false },
      reset: { quit: false },
      restore: { quit: false },
    },
    sources: ["git_status"],
  });
}

// X<ddu-locals>
// L<ddu-ui-ff-aliases> も直す
function setupLocals(args: ConfigArguments) {
  // X<ddu-local-mr>
  for (const type of ["mru", "mrw", "mrr"]) {
    args.contextBuilder.patchLocal(type, {
      sources: [{
        name: "mr",
        options: {
          converters: ["converter_hl_dir"],
        },
        params: {
          kind: type,
        },
      }],
    });
  }
  // X<ddu-local-dpp>
  args.contextBuilder.patchLocal("dpp", {
    sources: [{
      name: "dpp",
      options: {
        ...Filters.fzf_random_first,
      },
    }],
  });
  args.contextBuilder.patchLocal("file_ext_mrw", {
    sources: [{
      name: "file_external",
      options: {
        ...Filters.mtime_substring,
      },
    }],
  });
  args.contextBuilder.patchLocal("file_rec_mrw", {
    sources: [{
      name: "file_rec",
      options: {
        ...Filters.mtime_substring,
      },
    }],
  });
  // X<ddu-local-git_diff>
  args.contextBuilder.patchLocal("git_diff", {
    actionOptions: {
      applyPatch: { quit: false },
    },
    sources: ["git_diff"],
    uiParams: {
      ff: {
        maxDisplayItems: 100000,
        maxHighlightItems: 100000,
      },
    },
  });
  // X<ddu-local-help>
  args.contextBuilder.patchLocal("help", {
    sources: ["help"],
  });
  // X<ddu-local-line>
  args.contextBuilder.patchLocal("line", {
    sources: ["line"],
  });
  // X<ddu-local-lsp>
  args.contextBuilder.patchLocal("lsp", {
    // b:ddu_source_lsp_clientNameをセットしているため
    // sync付けてないと参照できない
    sync: true,
  });
  // X<ddu-local-tags>
  args.contextBuilder.patchLocal("tags", {
    sources: ["tags"],
    sync: true,
  });
}

function mainConfig(args: ConfigArguments) {
  // X<ddu-global>
  args.contextBuilder.patchGlobal({
    actionOptions: {
      narrow: {
        quit: false,
      },
    },
    filterParams: {
      // X<ddu-filter-converter_hl_dir>
      converter_hl_dir: {
        hlGroup: "String",
      },
      // X<ddu-filter-matcher_fzf>
      matcher_fzf: {
        highlightMatched: "DduMatch",
      },
    },
    kindOptions: {
      callback: { defaultAction: "call" },
      // X<ddu-kind-file>
      file: {
        defaultAction: "open",
      },
      help: { defaultAction: "tabopen" },
      lsp: { defaultAction: "open" },
      lsp_codeAction: { defaultAction: "apply" },
      tag: { defaultAction: "jump" },
    },
    postFilters: ["converter_normalize_hl"],
    sourceOptions: {
      _: {
        ignoreCase: true,
        ...Filters.fzf,
      },
      help: {
        ...Filters.fzf_random_first,
      },
    },
    sourceParams: {
      file_external: {
        cmd: ["fd", ".", "-H", "-I", "-E", ".git", "-t", "f"],
      },
    },
  });

  setupGitStatus(args);
  setupLocals(args);
}

/* selector section */

type Promisify<T> = T | Promise<T>;

// 環境から情報を収集してオプションに変える感じで
type POptions = Promisify<Partial<DduOptions>>;
type Collector = (denops: Denops) => POptions;

async function ripgrepLive(
  denops: Denops,
  findPath: (denops: Denops) => Promise<string>,
): Promise<Awaited<POptions>> {
  // ddu-source-rg is set to lazy, load it.
  await denops.call("dpp#source", "ddu-source-rg");
  return {
    name: "file:rg",
    sources: [{
      name: "rg",
      options: {
        ...Filters.live_grep,
        path: await findPath(denops),
        volatile: true,
      },
    }],
    uiParams: {
      ff: {
        ignoreEmpty: false,
        autoResize: false,
      },
    },
  };
}

// X<ddu-config-selector_definitions>
const definition: Record<string, Collector> = {
  file: async (denops) => ({
    name: "file",
    sources: [{
      name: "file",
      options: {
        path: String(await denops.call("expand", "%:p:h")),
        matchers: [],
        sorters: ["sorter_alpha"],
        converters: [],
      },
    }],
    searchPath: String(await denops.call("expand", "%:p")),
    sync: true,
  }),
  filer: async (denops) => {
    await denops.dispatcher.loadConfig(
      await denops.call("expand", "$VIMDIR/conf/plug/ddu/filer.ts"),
    );
    return {
      name: "filer",
      sources: [{
        name: "file",
        options: {
          columns: ["filename"],
          path: String(await denops.call("expand", "%:p:h")),
        },
      }],
      // syncとsearchPathによりrevealできるらしい
      searchPath: String(await denops.call("expand", "%:p")),
      sync: true,
      ui: "filer",
    };
  },
  git_branch: async (denops) => ({
    name: "git_branch",
    sources: [{
      name: "git_branch",
      options: {
        path: String(await denops.call("expand", "%:p:h")),
      },
      params: {
        remote: true,
      },
    }],
  }),
  git_diff: async (denops) => ({
    name: "git_diff",
    sourceOptions: {
      git_diff: {
        path: String(await denops.call("expand", "%:p")),
      },
    },
  }),
  github_repo_pull: async (denops) => {
    // L<dpp-lazy-ddu_source_github>
    await denops.call("dpp#source", "ddu-source-github");
    return {
      name: "github_repo_pull",
      sources: [{
        name: "github_repo_pull",
        params: {
          path: await denops.call("expand", "%:p:h"),
        },
      }],
    };
  },
  live_grep: (denops) =>
    ripgrepLive(
      denops,
      async (denops) => String(await denops.call("expand", "%:p:h")),
    ),
  live_grep_git: (denops) =>
    ripgrepLive(
      denops,
      async (denops) => String(await denops.call("gin#util#worktree")),
    ),
  // X<ddu-config-selector-lsp>
  lsp_codeAction: () => ({
    name: "lsp",
    sources: [{
      name: "lsp_codeAction",
    }],
  }),
  lsp_definition: () => ({
    name: "lsp",
    sources: ["lsp_definition"],
  }),
  lsp_diagnostic: () => ({
    name: "lsp",
    sources: [{
      name: "lsp_diagnostic",
      params: {
        clientName: "lspoints",
        buffer: 0,
      },
    }],
  }),
  lsp_references: () => ({
    name: "lsp",
    sources: ["lsp_references"],
  }),
  quickfix: () => ({
    name: "file",
    sources: ["qf"],
  }),
};

async function selectorConfig(args: ConfigArguments) {
  const { denops } = args;
  const ddu = dduHelper(denops);
  await map(denops, ";s", () => {
    // コレクターを選んで実行しdduに渡す
    ddu.start(
      sourceList.buildOptions(
        Object.keys(definition).sort(),
        async (items) => {
          if (items[0] != null) {
            await denops.call(
              "histadd",
              ":",
              "DduSelectorCall " + items[0].word,
            );
            ddu.start(await definition[items[0].word](denops));
          }
          return ActionFlags.None;
        },
      ),
    );
  }, {
    noremap: true,
  });
  await cmd(denops, "DduSelectorCall", async (args) => {
    const def = await definition[args.arg]?.(denops);
    if (def == null) {
      throw Error(`DduSelectorCall failed: ${args.arg}`);
    }
    ddu.start(def);
  });
}

export class Config extends BaseConfig {
  async config(args: ConfigArguments) {
    mainConfig(args);
    await selectorConfig(args);
    await autocmd.define(args.denops, "User", "vimrc#ddu#ready", ":");
    autocmd.emit(args.denops, "User", "vimrc#ddu#ready");
  }
}

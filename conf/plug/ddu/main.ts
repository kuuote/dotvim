import * as sourceList from "../../../denops/@ddu-sources/list.ts";
import { type KindGitStatusActionData } from "../../../denops/@deps/ddu-kinds.ts";
import { is, u } from "../../../denops/@deps/unknownutil.ts";
import { group, register } from "../../../denops/@vimrc/lib/lambda/autocmd.ts";
import { cmd, map } from "../../../denops/@vimrc/lib/lambda/map.ts";
import { dduHelper } from "./lib/helper.ts";
import {
  ActionFlags,
  BaseConfig,
  type ConfigArguments,
  type DduOptions,
  type SourceOptions,
} from "/data/vim/deps/ddu.ts";
import * as stdpath from "/data/vim/deps/deno_std/path/mod.ts";
import { autocmd, type Denops } from "/data/vim/deps/denops_std.ts";

const augroup = "vimrc#ddu";

/* main section */

type Filter = {
  matchers: SourceOptions["matchers"];
  sorters: SourceOptions["sorters"];
  converters: SourceOptions["converters"];
};

type Filters = Record<string, Filter>;

// satisfiesしておくとRecordにはならないので便利
const Filters = {
  fzf: {
    matchers: ["matcher_fzf"],
    sorters: ["sorter_fzf"],
    converters: [],
  },
  fzf_shuffle: {
    matchers: ["matcher_fzf"],
    sorters: ["sorter_shuffle", "sorter_fzf"],
    converters: [],
  },
  sorter_alpha_path: {
    matchers: [],
    sorters: ["sorter_alpha_path"],
    converters: [],
  },
  mtime_substring: {
    matchers: ["matcher_substring"],
    sorters: ["sorter_mtime"],
    converters: [],
  },
} satisfies Filters;

const FiltersLocal = {
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
} satisfies Filters;

async function setupPathPatch(args: ConfigArguments) {
  await group(args.denops, augroup, (helper) => {
    helper.define("BufEnter", "*", async () => {
      const [buftype, path] = await args.denops.eval(
        '[&l:buftype, expand("%:p:h")]',
      ) as [string, string];
      if (buftype == "") {
        args.contextBuilder.patchGlobal({
          sourceOptions: {
            _: {
              path,
            },
          },
        });
      }
    });
  });
}

function setupGitStatus(args: ConfigArguments) {
  const ddu = dduHelper(args.denops);
  args.contextBuilder.patchGlobal({
    kindOptions: {
      git_status: {
        actions: {
          commit: async () => {
            await args.denops.call("p#gin#komitto");
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
  for (const type of ["mru", "mrw", "mrr", "mrd"]) {
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
        ...Filters.fzf_shuffle,
      },
    }],
  });
  // X<ddu-local-file_rec>
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
  // X<ddu-local-file>
  args.contextBuilder.patchLocal("file", {
    // sources: ["file"],
    sourceOptions: {
      "file": {
        ...Filters.sorter_alpha_path,
      },
    },
    sync: true,
    uiParams: {
      ff: {
        maxDisplayItems: 10000,
      },
    },
  });
}

async function mainConfig(args: ConfigArguments) {
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
      // X<ddu-filter-matcher_kensaku>
      matcher_kensaku: {
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
    postFilters: [{
      name: "converter_color",
      params: {
        group: "DduNormal",
      },
    }, "converter_normalize_hl"],
    sourceOptions: {
      _: {
        ignoreCase: true,
        ...Filters.fzf,
      },
      help: {
        ...Filters.fzf_shuffle,
      },
    },
    sourceParams: {
      file_external: {
        cmd: ["fd", ".", "-H", "-I", "-E", ".git", "-t", "f"],
      },
    },
  });

  await setupPathPatch(args);
  setupGitStatus(args);
  setupLocals(args);
}

/* selector section */

type Promisify<T> = T | Promise<T>;

// 環境から情報を収集してオプションに変える感じで
type POptions = Promisify<Partial<DduOptions>>;
type Collector = (denops: Denops) => POptions;

async function ripgrep(
  denops: Denops,
  findPath: (denops: Denops) => Promise<string>,
  live: boolean,
): Promise<Awaited<POptions>> {
  // ddu-source-rg is set to lazy, load it.
  await denops.call("dpp#source", ["ddu-source-rg"]);
  return {
    name: "file:rg",
    sources: [{
      name: "rg",
      options: {
        ...Filters.sorter_alpha_path,
        path: await findPath(denops),
        volatile: live,
      },
      params: live
        ? {}
        : { input: String(await denops.call("input", "Pattern: ")) },
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
    sourceOptions: {
      file: {
        path: String(await denops.call("expand", "%:p:h")),
      },
    },
    searchPath: String(await denops.call("expand", "%:p")),
    sync: true,
  }),
  filer: async (denops) => {
    await denops.dispatcher.loadConfig(
      await denops.call("expand", "$MYVIMDIR/conf/plug/ddu/filer.ts"),
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
  grep: (denops) =>
    ripgrep(
      denops,
      async (denops) => String(await denops.call("expand", "%:p:h")),
      false,
    ),
  grep_git: (denops) =>
    ripgrep(
      denops,
      async (denops) => String(await denops.call("vimrc#git#find_root")),
      false,
    ),
  live_grep: (denops) =>
    ripgrep(
      denops,
      async (denops) => String(await denops.call("expand", "%:p:h")),
      true,
    ),
  live_grep_git: (denops) =>
    ripgrep(
      denops,
      async (denops) => String(await denops.call("vimrc#git#find_root")),
      true,
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
    await autocmd.group(args.denops, augroup, (helper) => {
      helper.remove("*");
      helper.define("User", "vimrc#ddu#ready", ":", { once: true });
    });
    mainConfig(args);
    await selectorConfig(args);
    autocmd.emit(args.denops, "User", "vimrc#ddu#ready");
  }
}

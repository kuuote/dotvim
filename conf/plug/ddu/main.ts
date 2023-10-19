import {
  ActionFlags,
  BaseConfig,
  ConfigArguments,
  DduOptions,
} from "../../../denops/deps/ddu.ts";
import { ActionData as GitStatusActionData } from "/data/vim/repos/github.com/kuuote/ddu-source-git_status/denops/@ddu-kinds/git_status.ts";
import { cmd, map } from "../../../denops/@vimrc/lib/lambda/map.ts";
import { dduHelper } from "./lib/helper.ts";
import { Denops, function as fn } from "../../../denops/deps/denops_std.ts";
import { is, maybe } from "../../../denops/deps/unknownutil.ts";
import { stdpath } from "../../../denops/deps/deno_std.ts";
import * as sourceList from "../../../denops/@ddu-sources/list.ts";

/* main section */

function setupGitStatus(args: ConfigArguments) {
  const ddu = dduHelper(args.denops);
  args.contextBuilder.patchGlobal({
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
    sourceOptions: {
      // X<ddu-source-git_status>
      git_status: {
        converters: [
          "converter_hl_dir",
          "converter_git_status",
        ],
      },
    },
    kindOptions: {
      callback: { defaultAction: "call" },
      git_status: {
        actions: {
          commit: async () => {
            await args.denops.call("funnygit#commit");
            // await args.denops.cmd("Gin commit");
            return ActionFlags.None;
          },
          diff: (args) => {
            const action = args.items[0].action as GitStatusActionData;
            const path = stdpath.join(action.worktree, action.path);
            ddu.start({
              name: "git_diff",
              sources: [{
                name: "git_diff",
                options: {
                  path,
                },
                params: {
                  ...maybe(args.actionParams, is.Record) ?? {},
                  onlyFile: true,
                },
              }],
            });
            return Promise.resolve(ActionFlags.None);
          },
          patch: async (args) => {
            for (const item of args.items) {
              const action = item.action as GitStatusActionData;
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
        params: {
          kind: type,
        },
      }],
    });
  }
  // X<ddu-local-dpp>
  args.contextBuilder.patchLocal("dpp", {
    sources: ["dpp"],
  });
  args.contextBuilder.patchLocal("file_rec_mrw", {
    sources: [{
      name: "file_rec",
      options: {
        matchers: ["matcher_substring"],
        sorters: ["sorter_mtime"],
      },
    }],
  });
  // X<ddu-local-help>
  args.contextBuilder.patchLocal("help", {
    sources: ["help"],
  });
  // X<ddu-local-line>
  args.contextBuilder.patchLocal("line", {
    sources: ["line"],
  });
}

function mainConfig(args: ConfigArguments) {
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
      lsp: { defaultAction: "open" },
      lsp_codeAction: { defaultAction: "apply" },
    },
    sourceOptions: {
      _: {
        ignoreCase: true,
        matchers: defaultMatchers,
        sorters: defaultSorters,
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
        matchers: [],
        sorters: ["sorter_alpha_path"],
        converters: [],
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
  }),
  filer: async (denops) => {
    return {
      name: "filer",
      sources: [{
        name: "file",
        options: {
          path: String(await denops.call("expand", "%:p:h")),
        },
      }],
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
      async (denops) => await fn.expand(denops, "%:p:h") as string,
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
  }
}

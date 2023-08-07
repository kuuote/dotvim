import {
  BaseConfig,
  ConfigArguments,
} from "../../../deno/ddu.vim/denops/ddu/base/config.ts";
import {
  ActionFlags,
  DduOptions,
} from "../../../deno/ddu.vim/denops/ddu/types.ts";
import { Denops } from "../../../deno/denops_std/denops_std/mod.ts";
import * as fn from "../../../deno/denops_std/denops_std/function/mod.ts";
import * as sourceList from "../../../denops/@ddu-sources/list.ts";
import { map } from "../../../denops/@vimrc/lambda.ts";
import { dduHelper } from "./lib/helper.ts";

// 環境から情報を収集してオプションに変える感じで
type POptions = Promise<Partial<DduOptions>>;
type Collector = (denops: Denops) => POptions;

async function ripgrepLive(
  denops: Denops,
  findPath: (denops: Denops) => Promise<string>,
): POptions {
  // ddu-source-rg is set to lazy, load it.
  await denops.call("dein#source", "ddu-source-rg");
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
  github_repo_pull: async (denops) => ({
    name: "github_repo_pull",
    sources: [{
      name: "github_repo_pull",
      params: {
        path: await denops.call("expand", "%:p:h"),
      },
    }],
  }),
  live_grep: (denops) =>
    ripgrepLive(
      denops,
      async (denops) => await fn.expand(denops, "%:p:h") as string,
    ),
  // X<ddu-config-selector-lsp>
  lsp_definition: () =>
    Promise.resolve({
      name: "lsp_definition",
      sources: ["lsp_definition"],
    }),
};

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const { denops } = args;
    const ddu = dduHelper(denops);
    await map(denops, ";s", () => {
      // コレクターを選んで実行しdduに渡す
      ddu.start(
        sourceList.buildOptions(
          Object.keys(definition).sort(),
          async (items) => {
            if (items[0] != null) {
              ddu.start(await definition[items[0].word](denops));
            }
            return ActionFlags.None;
          },
        ),
      );
    }, {
      noremap: true,
    });
  }
}

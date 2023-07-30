import { ConfigArguments } from "../../../deno/ddu.vim/denops/ddu/base/config.ts";
import {
  ActionFlags,
  DduOptions,
} from "../../../deno/ddu.vim/denops/ddu/types.ts";
import * as fn from "../../../deno/denops_std/denops_std/function/mod.ts";
import { Denops } from "../../../deno/denops_std/denops_std/mod.ts";
import * as sourceList from "../../../denops/@ddu-sources/list.ts";
import { map } from "../../../denops/@vimrc/lambda.ts";
import { dduHelper } from "./helper.ts";

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

const definition: Record<string, Collector> = {
  live_grep: (denops) =>
    ripgrepLive(
      denops,
      async (denops) => await fn.expand(denops, "%:p:h") as string,
    ),
  lsp_definition: () =>
    Promise.resolve({
      name: "lsp_definition",
      sources: ["lsp_definition"],
    }),
};

export async function setupSelector(args: ConfigArguments) {
  const { denops } = args;
  const ddu = dduHelper(denops);
  await map(denops, ";s", async () => {
    // コレクターを選んで実行しdduに渡す
    await ddu.start(
      sourceList.buildOptions(
        Object.keys(definition).sort(),
        async (items) => {
          if (items[0] != null) {
            await ddu.start(await definition[items[0].word](denops));
          }
          return ActionFlags.None;
        },
      ),
    );
  }, {
    noremap: true,
  });
}

import {
  BaseConfig,
  type ConfigArguments,
  type SourceOptions,
} from "../../../denops/@deps/ddc.ts";

type Filters = Record<string, {
  matchers: SourceOptions["matchers"];
  sorters: SourceOptions["sorters"];
  converters: SourceOptions["converters"];
}>;

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    const filters = {
      fuzzy: {
        matchers: ["matcher_fuzzy"],
        sorters: ["sorter_fuzzy"],
        converters: ["converter_fuzzy"],
      },
      none: {
        matchers: [],
        sorters: [],
        converters: [],
      },
      sorter_fzf: {
        matchers: [],
        sorters: ["sorter_fzf"],
        converters: [],
      },
    } satisfies Filters;

    args.contextBuilder.patchGlobal(
      {
        autoCompleteEvents: [
          "InsertEnter",
          "TextChangedI",
          "TextChangedP",
          "TextChangedT",
          "CmdlineEnter",
          "CmdlineChanged",
        ],
        cmdlineSources: {
          "/": [],
          ":": ["cmdline"],
          "?": [],
          "@": [],
        },
        sources: ["yank", "around"],
        sourceOptions: {
          _: {
            ...filters.sorter_fzf,
            ignoreCase: true,
          },
          around: {
            mark: "周",
          },
          cmdline: {
            isVolatile: true,
            minAutoCompleteLength: 1,
            mark: "令",
          },
          file: {
            ...filters.none,
            sorters: ["sorter_file", "sorter_fzf"],
            forceCompletionPattern: "\\S/\\S*",
            mark: "紙",
          },
          input: {
            isVolatile: true,
            mark: "入",
            minAutoCompleteLength: 0,
          },
          line: {
            mark: "行",
          },
          "shell-native": {
            mark: "殻",
          },
          skkeleton: {
            ...filters.none,
            isVolatile: true,
            maxItems: 50,
            minAutoCompleteLength: 1,
            mark: "変",
          },
          skkeleton_okuri: {
            ...filters.none,
            isVolatile: true,
            mark: "送",
          },
          yank: {
            ...filters.fuzzy,
            mark: "貼",
          },
        },
        sourceParams: {
          lsp: {
            lspEngine: "lspoints",
          },
          "shell-native": {
            "shell": "fish",
          },
        },
        ui: "pum",
      },
    );
    return Promise.resolve();
  }
}

import {
  BaseConfig,
  ConfigArguments,
} from "../../deno/ddc.vim/denops/ddc/base/config.ts";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
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
        backspaceCompletion: true,
        cmdlineSources: {
          ":": ["cmdline"],
          "@": ["input"],
        },
        filterParams: {
          matcher_substring: {
            highlightMatched: "FuzzyAccent",
          },
        },
        sourceOptions: {
          _: {
            converters: ["converter_fuzzy"],
            ignoreCase: true,
            matchers: ["matcher_fuzzy"],
            sorters: ["sorter_fuzzy"],
          },
          around: {
            mark: "A",
          },
          buffer: {
            mark: "B",
          },
          cmdline: {
            minAutoCompleteLength: 1,
          },
          cmdline_help: {
            converters: [],
            matchers: ["matcher_gaps"],
            maxItems: 20,
            sorters: ["sorter_alignment"],
          },
          file: {
            converters: ["converter_fuzzy"],
            forceCompletionPattern: "\\S/\\S*",
            isVolatile: true,
            mark: "F",
            matchers: ["matcher_fuzzy"],
            minAutoCompleteLength: 1000,
            sorters: [
              "sorter_file",
              "sorter_fuzzy",
            ],
          },
          input: {
            isVolatile: true,
            mark: "I",
          },
          necovim: {
            mark: "V",
          },
          "nvim-lsp": {
            converters: [],
            forceCompletionPattern: "\\.\\w*|:\\w*|->\\w*",
            mark: "lsp",
            matchers: [],
            minAutoCompleteLength: 1,
            sorters: ["sorter_alignment"],
          },
          skkeleton: {
            converters: [],
            isVolatile: true,
            mark: "変",
            matchers: ["skkeleton"],
            maxItems: 50,
            minAutoCompleteLength: 1,
            sorters: [],
          },
        },
        sourceParams: {
          file: {
            filenameChars: "[:keyword:].",
            projFromCwdMaxItems: [0],
          },
        },
        ui: "pum",
      },
    );
    return Promise.resolve();
  }
}

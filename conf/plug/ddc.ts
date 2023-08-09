import {
  BaseConfig,
  ConfigArguments,
} from "../../deno/ddc.vim/denops/ddc/base/config.ts";
import * as fn from "../../deno/denops_std/denops_std/function/mod.ts";
import * as batch from "../../deno/denops_std/denops_std/batch/mod.ts";

// X<ddc-config-global>

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
          sorter_alignment: {
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
          line: {
            matchers: ["matcher_fuzzy"],
            sorters: ["sorter_alignment"],
            converters: [],
          },
          necovim: {
            mark: "V",
          },
          "nvim-lsp": {
            converters: [],
            // forceCompletionPattern: "\\.\\w*|:\\w*|->\\w*",
            mark: "lsp",
            matchers: [],
            sorters: ["sorter_alignment"],
          },
          "shell-native": {
            mark: "殻",
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
          skkeleton_okuri: {
            converters: [],
            isVolatile: true,
            mark: "送",
            matchers: [],
            maxItems: 5,
            minAutoCompleteLength: 1,
            sorters: [],
          },
        },
        sourceParams: {
          file: {
            filenameChars: "[:keyword:].",
            projFromCwdMaxItems: [0],
          },
          "nvim-lsp": {
            snippetEngine: 0,
          },
          "shell-native": {
            "shell": "fish",
          },
        },
        ui: "pum",
      },
    );
    args.contextBuilder.setContextGlobal(async (denops) => {
      const mode = await fn.mode(denops);
      if (mode === "i") {
        const type = await fn.getcmdwintype(denops);
        if (type === ":") {
          return {
            specialBufferCompletion: true,
            sources: ["line", "necovim"],
          };
        }
      }
      if (mode === "c") {
        const [type, line] = await batch.collect(denops, (helper) => [
          fn.getcmdtype(helper),
          fn.getcmdline(helper),
        ]);
        if (type === ":") {
          return {
            cmdlineSources: ["cmdline_help", "cmdline"],
          };
        }
      }
      return {};
    });
    return Promise.resolve();
  }
}

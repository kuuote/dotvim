import { BaseConfig, ConfigArguments } from "../../../denops/deps/ddc.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments) {
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
          ":": ["cmdline"],
        },
        sources: ["around"],
        sourceOptions: {
          _: {
            matchers: ["matcher_fuzzy"],
            sorters: ["sorter_fuzzy"],
            converters: ["converter_fuzzy"],
            ignoreCase: true,
          },
          around: {
            mark: "A",
          },
          cmdline: {
            isVolatile: true,
            minAutoCompleteLength: 1,
          },
          file: {
            forceCompletionPattern: "\\S/\\S*",
            mark: "F",
          },
          input: {
            isVolatile: true,
            mark: "I",
            minAutoCompleteLength: 0,
          },
          line: {
            mark: "行",
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
        },
        sourceParams: {
          "nvim-lsp": {
            lspEngine: "lspoints",
          },
          "shell-native": {
            "shell": "fish",
          },
        },
        ui: "pum",
      },
    );
  }
}

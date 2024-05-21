import { BaseConfig, ConfigArguments } from "../../../denops/@deps/ddc.ts";

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
        sources: ["yank", "around"],
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
            sorters: ["sorter_file", "sorter_fuzzy"],
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
            matchers: [],
            sorters: [],
            isVolatile: true,
            maxItems: 50,
            minAutoCompleteLength: 1,
            mark: "変",
          },
          skkeleton_okuri: {
            matchers: [],
            sorters: [],
            converters: [],
            isVolatile: true,
            mark: "送",
          },
          yank: {
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
  }
}

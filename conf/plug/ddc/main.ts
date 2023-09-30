import { BaseConfig } from "/data/vim/repos/github.com/Shougo/ddc.vim/denops/ddc/base/config.ts";

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
        sources: ['around'],
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
        },
        ui: "pum",
      },
    );
  }
}

import {
  BaseConfig,
  ConfigArguments,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/base/config.ts";

const augroup = "vimrc#ddu-ui-filer";

export class Config extends BaseConfig {
  config(args: ConfigArguments) {
    const nvim = args.denops.meta.host === "nvim";
    args.contextBuilder.patchGlobal({
      uiParams: {
        filer: {
          split: nvim ? "floating" : "horizontal",
        },
      },
    });
  }
}

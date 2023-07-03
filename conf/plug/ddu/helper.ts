import { Denops } from "../../../deno/denops_std/denops_std/mod.ts";
import { DduOptions } from "../../../deno/ddu.vim/denops/ddu/types.ts";

// 型wrapper
// いるものしか定義してないので適宜増やすこと

class Helper {
  denops: Denops;
  constructor(denops: Denops) {
    this.denops = denops;
  }
  start(options: Partial<DduOptions>) {
    return this.denops.call("ddu#start", options);
  }
}

export function dduHelper(denops: Denops) {
  return new Helper(denops);
}

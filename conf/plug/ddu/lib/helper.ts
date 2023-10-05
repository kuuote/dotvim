import {
  DduItem,
  DduOptions,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/types.ts";
import { Denops } from "/data/vim/repos/github.com/vim-denops/deno-denops-std/denops_std/mod.ts";

// 型wrapper
// いるものしか定義してないので適宜増やすこと

class Helper {
  denops: Denops;
  constructor(denops: Denops) {
    this.denops = denops;
  }
  start(options: Partial<DduOptions>) {
    // return this.denops.call("ddu#start", options);
    // こうしておくとその場でカスタムアクションとか作って渡せるはず
    return this.denops.dispatcher.start(options);
  }
  getItemActionNames(name: string, items: DduItem[]) {
    return this.denops.dispatcher.getItemActionNames(
      name,
      items,
    ) as Promise<string[]>;
  }
  itemAction(
    name: string,
    action: string,
    items: DduItem[],
    params: Record<string, unknown>,
  ) {
    return this.denops.call("ddu#item_action", name, action, items, params);
  }
  uiSyncAction(name: string, params: Record<string, unknown> = {}) {
    return this.denops.call("ddu#ui#sync_action", name, params);
  }
  uiGetSelectedItems() {
    return this.denops.call("ddu#ui#get_selected_items") as Promise<DduItem[]>;
  }
}

export function dduHelper(denops: Denops) {
  return new Helper(denops);
}

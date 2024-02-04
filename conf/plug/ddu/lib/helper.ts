import {
  DduItem,
  DduOptions,
} from "../../../../denops/@deps/ddu.ts";
import { Denops } from "../../../../denops/@deps/denops_std.ts";

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

import {
  BaseFilter,
  FilterArguments,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/base/filter.ts";
import {
  DduItem,
  Item,
} from "/data/vim/repos/github.com/Shougo/ddu.vim/denops/ddu/types.ts";
import { ActionData } from "/data/vim/repos/github.com/Shougo/ddu-kind-file/denops/@ddu-kinds/file.ts";

type Never = Record<PropertyKey, never>;

const cache = new WeakMap<WeakKey, Map<string, Promise<Deno.FileInfo>>>();

function ensureWeakMap<T>(
  map: WeakMap<WeakKey, T>,
  key: WeakKey,
  factory: () => T,
) {
  const value = map.get(key);
  if (value != null) {
    return value;
  }
  const newValue = factory();
  map.set(key, newValue);
  return newValue;
}

function ensureMap<T, U>(
  map: Map<T, U>,
  key: T,
  factory: () => U,
) {
  const value = map.get(key);
  if (value != null) {
    return value;
  }
  const newValue = factory();
  map.set(key, newValue);
  return newValue;
}

export class Filter extends BaseFilter<Never> {
  async filter(args: FilterArguments<Never>) {
    const vault = ensureWeakMap(cache, args.context, () => new Map());
    const mtime = async (item: Item): Promise<[Item, number]> => {
      const t = item.status?.time;
      if (t != null) {
        return [item, t];
      }
      const path = (item.action as ActionData)?.path ?? "";
      // cache path for multiline source(e.g. grep)
      try {
        const stat = ensureMap(vault, path, () => Deno.stat(path));
        return [
          item,
          (await stat).mtime?.getTime() ?? 0,
        ];
      } catch {
        // unknown path is force old
        return [item, 0];
      }
    };
    return (await Promise.all((args.items as Item[]).map(mtime)))
      .sort((a, b) => b[1] - a[1])
      .map((t) => t[0] as DduItem);
  }
  params() {
    return {};
  }
}

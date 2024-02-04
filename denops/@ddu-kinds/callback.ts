import {
  ActionArguments,
  ActionFlags,
  BaseKind,
  DduItem,
} from "../@deps/ddu.ts";

export type Callback = string | ((items: DduItem[]) => Promise<ActionFlags>);

export type Params = {
  callback: Callback;
};

export class Kind extends BaseKind<Params> {
  override actions: Record<
    string,
    (args: ActionArguments<Params>) => Promise<ActionFlags>
  > = {
    call: async (args) => {
      const callback = args.kindParams.callback;
      if (typeof callback === "function") {
        return await callback(args.items);
      } else {
        return await args.denops.call(
          "denops#callback#call",
          callback,
          args.items,
        ) as Promise<ActionFlags>;
      }
    },
  };
  override params(): Params {
    return {
      callback: () => Promise.resolve(ActionFlags.None),
    };
  }
}

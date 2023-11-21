import {
  BaseSource,
  GatherArguments,
  Item,
  OnCompleteDoneArguments,
} from "../deps/ddc.ts";
import { is, u } from "../deps/unknownutil.ts";

export type Params = {
  candidates: Array<string | Item>;
  callback?: string | ((args: OnCompleteDoneArguments<Params>) => unknown);
};

export class Source extends BaseSource<Params> {
  override gather({ sourceParams }: GatherArguments<Params>): Promise<Item[]> {
    return Promise.resolve(
      sourceParams.candidates.map((candidate) => {
        if (is.String(candidate)) {
          return {
            word: candidate,
            user_data: {
              word: candidate,
            },
          };
        } else {
          return {
            ...candidate,
            user_data: u.maybe(candidate.user_data, is.Record) ?? {},
          };
        }
      }),
    );
  }

  override params(): Params {
    return {
      candidates: [],
    };
  }

  override async onCompleteDone(
    args: OnCompleteDoneArguments<Params>,
  ) {
    const callback = args.sourceParams.callback;
    if (typeof callback === "string") {
      await args.denops.call(
        "denops#callback#call",
        args.sourceParams.callback,
        args,
      );
    } else if (typeof callback === "function") {
      await callback(args);
    }
  }
}

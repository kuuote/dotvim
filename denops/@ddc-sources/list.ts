import { GatherArguments } from "https://deno.land/x/ddc_vim@v3.2.0/base/source.ts";
import { BaseSource, Item } from "https://deno.land/x/ddc_vim@v3.2.0/types.ts";

type Params = {
  candidates: string[];
};

export class Source extends BaseSource<Params> {
  override gather({ sourceParams }: GatherArguments<Params>): Promise<Item[]> {
    return Promise.resolve(sourceParams.candidates.map((word) => ({ word })));
  }

  override params(): Params {
    return {
      candidates: [],
    };
  }
}

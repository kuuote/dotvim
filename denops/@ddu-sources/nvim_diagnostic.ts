import { Denops, fn } from "https://deno.land/x/ddu_vim@v2.0.0/deps.ts";
import { BaseSource, Item } from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.2/file.ts";

const Severity = {
  ERROR: 1,
  WARN: 2,
  INFO: 3,
  HINT: 4,
} as const;

type Severity = typeof Severity[keyof typeof Severity];

// from :h diagnostic-structure
type Diagnostic = {
  bufnr: number;
  lnum: number;
  end_lnum: number;
  col: number;
  end_col: number;
  severity: Severity;
  message: string;
  source: string;
  code: number;
  user_data: unknown;
};

type Params = {
  buffer?: number;
};

export class Source extends BaseSource<Params> {
  override kind = "file";

  override gather(args: {
    denops: Denops;
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        const diagnostics = await args.denops.call(
          "luaeval",
          "vim.diagnostic.get(_A)",
          args.sourceParams.buffer,
        ) as Diagnostic[];
        controller.enqueue(diagnostics.map((d, idx) => {
          return {
            word: d.message,
            action: {
              bufNr: d.bufnr,
              lineNr: d.lnum + 1,
              _idx: idx,
            },
          };
        }));

        controller.close();
      },
    });
  }

  override params(): Params {
    return {};
  }
}

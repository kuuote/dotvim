import { batch } from "../../deno/denops_std/denops_std/batch/mod.ts";
import { Denops } from "../../deno/lspoints/denops/lspoints/deps/denops.ts";
import { LSP } from "../../deno/lspoints/denops/lspoints/deps/lsp.ts";
import { u } from "../../deno/lspoints/denops/lspoints/deps/unknownutil.ts";
import {
  BaseExtension,
  Client,
  Lspoints,
} from "../../deno/lspoints/denops/lspoints/interface.ts";

const NSID = "lspoints_semantic_tokens";

type Token = {
  line: number;
  character: number;
  length: number;
  type: string;
  modifiers: string;
};

function parse(tokens: number[], legend: LSP.SemanticTokensLegend): Token[] {
  const parsed = [];
  let curline = 0;
  let curchar = 0;
  for (let i = 0; i < tokens.length; i += 5) {
    const line = curline += tokens[i];
    if (tokens[i] != 0) {
      curchar = 0;
    }
    const character = curchar += tokens[i + 1];
    const length = tokens[i + 2];
    const type = legend.tokenTypes[tokens[i + 3]] ?? "";
    const modifiers = legend.tokenModifiers[tokens[i + 4]] ?? "";
    parsed.push({
      line,
      character,
      length,
      type,
      modifiers,
    });
  }
  return parsed;
}

async function request(
  lspoints: Lspoints,
  bufnr: number,
): Promise<[Client, Token[]][]> {
  const clients = lspoints.getClients(Number(bufnr)).filter((c) =>
    c.serverCapabilities.semanticTokensProvider?.full
  );
  return await Promise.all(
    clients.map(async (client): Promise<[Client, Token[]]> => {
      const result = await lspoints.request(
        client.name,
        "textDocument/semanticTokens/full",
        {
          textDocument: {
            uri: client.getUriFromBufNr(bufnr),
          },
        },
      ) as { data: number[] };
      return [
        client,
        parse(
          result.data,
          client.serverCapabilities.semanticTokensProvider!.legend,
        ),
      ];
    }),
  );
}

export class Extension extends BaseExtension {
  namespace_id = -1;
  override async initialize(denops: Denops, lspoints: Lspoints) {
    if (denops.meta.host === "nvim") {
      this.namespace_id = Number(
        await denops.call("nvim_create_namespace", NSID),
      );
    }
    lspoints.defineCommands("semantic_tokens", {
      apply: async (_bufnr: unknown) => {
        const bufnr = u.maybe(_bufnr, u.isNumber) ??
          Number(await denops.call("bufnr"));
        const result = await request(lspoints, bufnr);
        if (denops.meta.host === "nvim") {
          batch(denops, async (helper) => {
            await helper.call(
              "nvim_buf_clear_namespace",
              bufnr,
              this.namespace_id,
              0,
              -1,
            );
            for (const [, tokens] of result) {
              for (const token of tokens) {
                await helper.call(
                  "nvim_buf_add_highlight",
                  bufnr,
                  this.namespace_id,
                  "@" + token.type,
                  token.line,
                  token.character,
                  token.character + token.length,
                );
              }
            }
          });
        }
      },
      print: async () => {
        const result = await request(
          lspoints,
          Number(await denops.call("bufnr")),
        );
        for (const [client, tokens] of result) {
          console.log(client.name);
          console.log(client.serverCapabilities.semanticTokensProvider);
          console.log(tokens);
        }
      },
    });
    denops.cmd("mes clear | echomsg msg", { msg: "loaded" });
  }
}

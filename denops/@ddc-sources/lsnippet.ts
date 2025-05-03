import {
  BaseSource,
  GatherArguments,
  OnCompleteDoneArguments,
} from "jsr:@shougo/ddc-vim/source";
import { Item } from "jsr:@shougo/ddc-vim/types";
import * as lambda from "jsr:@denops/std/lambda";

type Snippet = {
  word: string;
  body: string | (() => Promise<string>);
};

let Thunks: (() => Promise<string>)[] = [];

type Never = Record<PropertyKey, never>;

// loader for lsp snippets

export class Source extends BaseSource<Never> {
  override async gather({ denops }: GatherArguments<Never>): Promise<Item[]> {
    Thunks.length = 0;

    const snippets: Snippet[] = [];

    const head = Number(await denops.call("line", ".")) === 1;
    const filetype = String(await denops.eval("&l:filetype"));

    if (head) {
      snippets.push({
        word: "bash",
        body: [
          "#!/usr/bin/env bash",
          "set -euo pipefail",
          "$0",
        ].join("\n"),
      });
    }

    if (filetype === "ai") {
      snippets.push({
        word: "translate",
        body:
          "以下の文章を日本語に翻訳してください。結果だけを出力してください",
      });
    }

    if (filetype === "nix") {
      if (head) {
        snippets.push({
          word: "mkshell",
          body: [
            "{",
            "\tpkgs ? import <nixpkgs> { },",
            "}:",
            "pkgs.mkShell {",
            "\tpackages = with pkgs; [",
            "\t\t$0",
            "\t];",
            "}",
          ].join("\n"),
        });
        snippets.push({
          word: "nixpkgs",
          body: [
            "{",
            "\tpkgs ? import <nixpkgs> { },",
            "}:",
            "$0",
          ].join("\n"),
        });
      }
    }

    if (filetype === "vim") {
      snippets.push({
        word: "autoload_function",
        body: async () => {
          const path = String(await denops.call("expand", "%:p"));
          const match = path.match(/autoload\/(.+?)\.vim$/);
          if (match === null) {
            return "";
          }
          const fn = match[1].replaceAll("/", "#");

          return [
            `function ${fn}#$0() abort`,
            "endfunction",
          ].join("\n");
        },
      });
    }

    Thunks = [];
    return snippets.map(({ word, body }) => {
      let snippet: number | string;
      if (typeof body === "function") {
        Thunks.push(body);
        snippet = Thunks.length - 1;
      } else {
        snippet = body;
      }
      return {
        word,
        user_data: {
          snippet,
        },
      };
    });
  }

  override async onCompleteDone(
    { denops, userData }: OnCompleteDoneArguments<Never>,
  ) {
    let { snippet } = userData as { snippet: number | string };
    if (typeof snippet === "number") {
      snippet = await Thunks[snippet]();
    }
    if (snippet === "") {
      return;
    }
    const lam = lambda.add(denops, async () => {
      try {
        if (denops.meta.host === "vim") {
          await denops.call("vsnip#anonymous", snippet);
        } else {
          await denops.call("luaeval", "vim.snippet.expand(_A)", snippet);
        }
      } finally {
        lam.dispose();
      }
    });
    await denops.eval(
      `feedkeys("\\<C-w>\\<Cmd>call ${lam.notify()}\\<CR>", "n")`,
    );
  }

  params(): Never {
    return {};
  }
}

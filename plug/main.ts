import { run, setProfile, use, useProfile } from "plug";
import { parse as parseArgs } from "https://deno.land/std@0.95.0/flags/mod.ts";

function init(profiles: string[]) {
  setProfile(profiles);

  use("hrsh7th/vim-vsnip"); // VSCode形式を使えるスニペットプラグイン
  use("junegunn/fzf"); // fzf-previewの前提
  use("kana/vim-textobj-entire"); // バッファ全体を対象とするテキストオブジェクト
  use("kana/vim-textobj-user"); // テキストオブジェクト追加用の補助プラグイン
  use("kuuote/vim-fuzzyhistory"); // cmdwin用selector
  use("lambdalisue/fern.vim"); // ふぁーん
  use("lambdalisue/gina.vim"); // Vimからgit操作するプラグイン
  use("lambdalisue/mr-quickfix.vim"); // mr.vim用の高速なインターフェース
  use("lambdalisue/mr.vim"); // MRUを記録するプラグイン
  use("lambdalisue/suda.vim"); // sudo経由でファイルを読み書きする
  use("machakann/vim-sandwich"); // 括弧を囲ってくれるすごいやつ
  use("mattn/vim-sonictemplate"); // 便利なテンプレートプラグイン
  use("thinca/vim-localrc"); // ローカルのvimrcを読み込んでくれる
  use("thinca/vim-quickrun"); // コマンドを素早く実行する
  use("tyru/capture.vim"); // コマンドの出力をバッファで開く
  use("tyru/eskk.vim"); // Nihongo Nyuuryoku suruyatu
  use("vim-denops/denops.vim"); // An ecosystem of Vim/Neovim which allows developers to write plugins in Deno
  use("yuki-yano/fern-preview.vim"); // ふぁーん用のプレビュープラグイン
  use("yuki-yano/fzf-preview.vim", { "branch": "release/rpc" }); // dark powered fzf plugin
  use('thinca/vim-qfreplace'); // quickfixに対して置換を行うプラグイン

  // colorscheme
  
  use("bluz71/vim-nightfly-guicolors");
  use("cormacrelf/vim-colors-github");
  use("ghifarit53/tokyonight-vim");
  use("kjssad/quantum.vim");
  use("lifepillar/vim-solarized8");
  use("sainnhe/edge");
  use("severij/vadelma");

  // lsp
  useProfile("vim-lsp", () => {

    use("mattn/vim-lsp-settings"); // vim-lspの設定をいい感じにしてくれるやつ
    use("prabirshrestha/asyncomplete-lsp.vim"); // asyncompleteとvim-lspの連携
    use("prabirshrestha/asyncomplete.vim"); // 自動補完
    use("prabirshrestha/vim-lsp"); // Pure Vim script LSP Client

  });

  // filetype

  use("udalov/kotlin-vim");
  use("zah/nim.vim");

  useProfile("vim", () => {

    use("mattn/vim-molder");

  });

  useProfile("nvim", () => {

    use("monaqa/dial.nvim"); // ぐりぐりするやつ
    use("nvim-lua/plenary.nvim"); // vitalみたいなやつ
    use("nvim-treesitter/nvim-treesitter"); // very sugoi syntax highlighter and more
    use("phaazon/hop.nvim"); // easy motion for nvim
    use("tamago324/lir.nvim"); // simple file explorer

    // telescope
    // use('nvim-lua/plenary.nvim') // 上にもあるのでコメントアウト
    use("nvim-lua/popup.nvim");
    use("nvim-telescope/telescope.nvim");
  });
}

async function main(args: string[]): Promise<number> {
  const parsed = parseArgs(args, {
    boolean: ["f"],
    string: ["r", "v"],
  });
  const option = {
    repositoryRoot: parsed.r ?? (Deno.env.get("HOME")! + "/.cache/plugins"),
    vimrc: parsed.v ?? (Deno.env.get("HOME")! + "/.vim/load.vim"),
    forceUpdate: !!parsed.f,
  };
  const command = String(parsed._[0]);
  const profiles = parsed._.map((v) => v.toString()).slice(1);
  init(profiles);
  await run(command, option);
  return 0;
}

Deno.exit(await main(Deno.args));

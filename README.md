# .vim

基本的に自分が使うことしか考えてないし普段の環境(ArchLinux)以外で動かすことも想定していないので他の環境に持っていっても動かない可能性がある

- 必要な物
  - Vim or Neovim
    - 基本的にHEADを使っている
      - 面倒臭いのでHEAD以外知らんという方針
    - 一部分をLuaで書いているためVimは`+lua`付きでコンパイルする必要がある
  - Deno
    - `denops.vim`を全面的に採用しているので必須
    - denopsはいいぞ
  - fzf
    - `fzf-preview.vim`や、ファイラーにセットしてるディレクトリ移動ショートカットに使っている
    - 自作セレクターにも使ってたな
  - ripgrep
    - 存在したら`:grep`で使われるようにしている他プラグインでも使われている
      - telescope.nvimの`live_grep`
      - `ddu-source-rg`

# 導入方法(例)

```sh
git clone https://github.com/kuuote/dotvim ~/.vim
mkdir -p ~/.config/nvim
ln -s ~/.vim/init.vim ~/.config/nvim/init.vim
```

```vim
:call dein#install()
```

```vim
:call vimrc#build#output()
```

```vim
" neovim only
:TSUpdate
```

# ライセンス

注釈が無い部分は基本的に[NYSL](http://www.kmonos.net/nysl/)(注釈を忘れている可能性はあるが)なので好きに持っていってもらって構いません

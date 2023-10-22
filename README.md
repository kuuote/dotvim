# .vim

基本的に自分が使うことしか考えてないし普段の環境(Arch Linux)以外で動かすことも想定していないので他の環境に持っていっても動かない可能性がある

- 必要な物
  - Vim or Neovim
    - 基本的にHEADを使っている
      - 面倒臭いのでHEAD以外知らんという方針
    - 一部分をLuaで書いているためVimは`+lua`付きでコンパイルする必要がある
  - Deno
    - `denops.vim`を全面的に採用しているので必須
    - denopsはいいぞ
  - ripgrep
  - `ddu-source-rg`で使っている

# 導入方法(例)

```sh
git clone https://github.com/kuuote/dotvim ~/dotvim
ln -s ~/dotvim ~/.vim
ln -s ~/.vim ~/.config/nvim
```

```vim
:call dpp#async_ext_action('installer', 'install')
```

# ライセンス

注釈が無い部分は基本的に[NYSL](http://www.kmonos.net/nysl/)(注釈を忘れている可能性はあるが)なので好きに持っていってもらって構いません

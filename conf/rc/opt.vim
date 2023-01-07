" スペースの2幅が好み
set expandtab
set tabstop=2
set shiftwidth=2

" 行番号大事
" set number
" set relativenumber

" swapfile
call mkdir('/tmp/vimswap', 'p')
set directory=/tmp/vimswap//

" diffを垂直に並べる
set diffopt+=vertical

" システムのクリップボードを使う
set clipboard=unnamedplus

" いい感じのBackspace
set backspace=indent,eol,start " いい感じにBackspaceが効くように

" ファイルを変更したまま裏に移動できるようにする
set hidden

" マウスでスクロールできるようにする
set mouse=nvr

" フルカラーは人権
set termguicolors

" タイムアウトを設けることによりEscを単体で入力できるようにする
set ttimeout
" defaults.vimより
set ttimeoutlen=100

" 検索の時にケースを無視
set ignorecase

" 履歴を増やす
set history=10000

" https://github.com/tsuyoshicho/vimrc-reading/blob/4037e59bdfaad9063c859e5fe724579623ef7836/.vimrc#L1294-L1298
" ファイルパスの@を利用可能にする
" = は使われないはずなので除外
set isfname&
  \ isfname+=@-@
  \ isfname-==

" from https://github.com/Shougo/shougo-s-github/blob/8504d14d2d057a485b5b96f6632c6369fb93c7c0/vim/rc/options.rc.vim#L320
" Display an invisible letter with hex format.
set display+=uhex

" 手動補完の挙動を自動補完っぽく(自動ではない)
set completeopt=menuone,noselect

" セッション使っていき
set sessionoptions=blank,curdir,tabpages

" スペースの2幅が好み
set expandtab
set tabstop=2
set shiftwidth=2

" 行番号大事
set number
set relativenumber

" swapfile
call mkdir('/tmp/vimswap', 'p')
set directory=/tmp/vimswap//

" diffを垂直に並べる
set diffopt+=vertical

" システムのクリップボードを使う
set clipboard=unnamedplus

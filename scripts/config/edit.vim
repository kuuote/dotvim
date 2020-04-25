set modeline
set modelines=5

syntax enable
filetype plugin indent on

set tabstop=2
set autoindent
set expandtab
set shiftwidth=2

"コマンドライン補完等で大文字打つのが面倒なので無視
set ignorecase

set backspace=indent,eol,start
set autoread
set pumheight=5
set hidden
set virtualedit=block
set nrformats-=octal

" シェルの変数のファイル名補完をするときに不便なので
set isfname-==

" ウィンドウを後方に向けて開く
set splitbelow
set splitright

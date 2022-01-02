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

" いい感じのBackspace
set backspace=indent,eol,start " いい感じにBackspaceが効くように

" ファイルを変更したまま裏に移動できるようにする
set hidden

" マウスでスクロールできるようにする
set mouse=nvr

" ddc.vimを使用しているとモード表示がちらつくので切る
set noshowmode

" フルカラーは人権
set termguicolors

" タイムアウトを設けることによりEscを単体で入力できるようにする
set ttimeout
" defaults.vimより
set ttimeoutlen=100

" 検索の時にケースを無視
set ignorecase

" 履歴を増やしてパスを変える
set history=1000
let &viminfo = "'1000,:1000" + ',n~/.vim/' .. g:vim_type .. '.info'


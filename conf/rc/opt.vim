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

" 検索の結果をリアルタイムで表示する
set incsearch

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

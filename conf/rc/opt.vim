" スペースの2幅が好み
set expandtab
set shiftwidth=2
set tabstop=2

" ファイルを変更したまま裏に移動できるようにする
set hidden

" フルカラーは人権
set termguicolors

" 立つ鳥後を濁さず
set viminfo+=:0

" スワップ固めような
set directory=/tmp/swp//
call mkdir('/tmp/swp', 'p')

" nullっとスクロール
set mouse=nv

" 文字無い所にもカーソル
set virtualedit=all

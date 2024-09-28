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

" 疑似submodeにマッピングのtimeoutが邪魔
set notimeout

" tabを閉じた際に開く前の方向に戻っていく
set tabclose=left

" たまーに判定に失敗する環境があって面倒
" システム側のロケール情報読めないとだめそう
set encoding=utf-8

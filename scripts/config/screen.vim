set ruler
set showcmd
set showmatch
set matchtime=1

"インクリメンタルサーチは便利
set incsearch
set hlsearch

set laststatus=2

"移動に便利なので相対行番号表示
set number
set relativenumber
"8.2のどこかで'cursorline'設定しないとCursorLineNrが適用されなくなった？
"Neovimにはない
if !has("nvim")
  set cursorline
  set cursorlineopt=number
endif

"たまにマウス使うので
set mouse=a

set diffopt=internal,filler,algorithm:histogram

" gvimみたいにカーソルを変化させる
" neovimだとこの設定自体がない
if !has("nvim")
  let &t_ti .= "\e[1 q"
  let &t_SI .= "\e[5 q"
  let &t_EI .= "\e[1 q"
  let &t_te .= "\e[0 q"
endif
set signcolumn=yes " signの欄を常に出す

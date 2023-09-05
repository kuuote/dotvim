augroup vimrc
  autocmd!
augroup END

let $DOTVIM = expand('<sfile>:p:h')
let $VIMRC = expand('<sfile>:p')

let g:vim_type = has('nvim') ? 'nvim' : 'vim'
let g:mapleader = "'"
let g:maplocalleader = ","

luafile $DOTVIM/conf/preload.lua

if !v:vim_did_enter
  source $DOTVIM/conf/dein.vim
endif

filetype plugin indent on
syntax enable

call vimrc#load_scripts('$DOTVIM/conf/rc/**/*')
call vimrc#load_scripts(printf('$DOTVIM/conf/%s/rc/**/*', g:vim_type))
call vimrc#load_scripts('/tmp/vimrc/*')

if getftype($DOTVIM .. '/local.vim') ==# 'file'
  source $DOTVIM/local.vim
endif

if empty(get(g:, 'colors_name', ''))
  set background=light
  colorscheme wildcharm
endif

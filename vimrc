augroup vimrc
  autocmd!
augroup END

let $DOTVIM = expand('<sfile>:p:h')
let $VIMRC = expand('<sfile>:p')

let g:vim_type = has('nvim') ? 'nvim' : 'vim'
let g:mapleader = "'"
let g:maplocalleader = ","

luafile ~/.vim/conf/preload.lua

if !v:vim_did_enter
  source ~/.vim/conf/dein.vim
endif

filetype plugin indent on
syntax enable

call vimrc#load_scripts('~/.vim/conf/rc/**/*')
call vimrc#load_scripts(printf('~/.vim/conf/%s/rc/**/*', g:vim_type))
call vimrc#load_scripts('/tmp/vimrc/*')

if getftype($DOTVIM .. '/local.vim') ==# 'file'
  source ~/.vim/local.vim
endif

if empty(get(g:, 'colors_name', ''))
  colorscheme habamax
endif

augroup vimrc
  autocmd!
augroup END

let g:dotvim = expand('<sfile>:p:h')

let g:vim_type = has('nvim') ? 'nvim' : 'vim'
let g:mapleader = "'"

" temporalily do nothing
command! -nargs=1 UsePlugin :

if !v:vim_did_enter
  execute 'source' '~/.vim/load_' .. g:vim_type .. '.vim'
endif

filetype plugin indent on
syntax enable

call vimrc#load_scripts('~/.vim/conf/rc/**/*.vim')
call vimrc#load_scripts(printf('~/.vim/conf/%s/rc/**/*.vim', g:vim_type))
call vimrc#load_scripts('~/.vim/conf/plug/**/*.vim')
call vimrc#load_scripts(printf('~/.vim/conf/%s/plug/**/*.vim', g:vim_type))

if getftype($HOME .. '/.vim/local.vim') ==# 'file'
  source ~/.vim/local.vim
endif

if empty(get(g:, 'colors_name', ''))
  set bg=dark
  colorscheme edge
endif

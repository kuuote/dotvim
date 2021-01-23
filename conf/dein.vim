let s:dein_repo = $HOME .. '/.vim/dein/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo)
  execute printf('!git clone https://github.com/Shougo/dein.vim %s', s:dein_repo)
endif
let &runtimepath ..= ',' .. s:dein_repo
let g:dein#auto_recache = 1
let g:dein#cache_directory = '/tmp/dein/cache/' .. g:progname_short
let s:dein_dir = '~/.vim/dein'
let s:rc = '~/.vim/conf/plug.vim'
let s:rc2 = has('nvim') ? '~/.vim/conf/nvim/plug.vim' : '~/.vim/conf/vim/plug.vim'
if dein#load_state('~/.vim/dein')
  call dein#begin('~/.vim/dein', [$MYVIMRC, expand('<sfile>'), s:rc, s:rc2])
  call dein#add('Shougo/dein.vim')
  execute 'source' s:rc
  execute 'source' s:rc2
  call dein#end()
  call dein#save_state()
endif

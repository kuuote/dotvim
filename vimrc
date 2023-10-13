set nocompatible
augroup vimrc
  autocmd!
augroup END

let $VIMDIR = expand('<sfile>:p:h')
set runtimepath^=$VIMDIR

if !v:vim_did_enter
  " ./conf/dpp.vim
  source $VIMDIR/conf/dpp.vim
  if get(g:, 'vimrc#dpp_make_state', v:false)
    source $VIMDIR/conf/fallback.vim
    finish
  endif
endif

call vimrc#inline#load('$VIMDIR/conf/rc/*.vim')
call vimrc#inline#load('$VIMDIR/local/rc/*.vim')

set termguicolors
if empty(get(g:, 'colors_name', ''))
  set background=light
  colorscheme edge
endif

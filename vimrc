set nocompatible
augroup vimrc
  autocmd!
augroup END

let $VIMDIR = expand('<sfile>:p:h')
set runtimepath^=$VIMDIR

" dpp.vim内でconf/rcやlocal/rc以下から設定を読んでいる
" L<dpp-inline_vimrcs>
if !v:vim_did_enter
  " ./conf/dpp.vim
  source $VIMDIR/conf/dpp.vim
endif

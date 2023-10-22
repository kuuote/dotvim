set nocompatible
augroup vimrc
  autocmd!
augroup END

let $VIMDIR = expand('<sfile>:p:h')
" vimrcを指定するかしないかでruntimepath変わって面倒なので固定値で上書き
" システムの設定などないし多分行けるでしょ(適当)
set runtimepath=$VIMDIR,$VIMRUNTIME,$VIMDIR/after

" dpp.vim内でconf/rcやlocal/rc以下から設定を読んでいる
" L<dpp-inline_vimrcs>
if !v:vim_did_enter
  source $VIMDIR/conf/dpp.vim
endif

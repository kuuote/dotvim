set nocompatible
augroup vimrc
  autocmd!
augroup END

let $MYVIMDIR = expand('<sfile>:p:h')
" vimrcを指定するかしないかでruntimepath変わって面倒なので固定値で上書き
" システムの設定などないし多分行けるでしょ(適当)
set runtimepath=$MYVIMDIR,$MYVIMDIR/local,$VIMRUNTIME,$MYVIMDIR/after,$MYVIMDIR/local/after

" dpp.vim内でconf/rcやlocal/rc以下から設定を読んでいる
" L<dpp-inline_vimrcs>
if !v:vim_did_enter
  source $MYVIMDIR/conf/dpp.vim
endif

filetype plugin indent on
autocmd vimrc FileType * ++once ++nested syntax enable

" デフォルトプラギンを無効化するやつ
" 何かしらのプラギンが読まれるまでVIMRUNTIME抜くのでそれに依存するけど
" うちはdenops.vim使ってるので問題Nothing!
let s:save_rtp = &runtimepath
set rtp-=$VIMRUNTIME
autocmd vimrc SourcePre */plugin/* ++once let &runtimepath = s:save_rtp

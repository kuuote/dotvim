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
  if get(g:, 'vimrc#dpp_make_state', v:false)
    source $VIMDIR/conf/fallback.vim
    finish
  endif
endif

set termguicolors
if empty(get(g:, 'colors_name', ''))
  set background=light
  colorscheme edge
endif

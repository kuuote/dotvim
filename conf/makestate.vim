call vimrc#git#use('https://github.com/vim-denops/denops.vim')
call vimrc#git#use('https://github.com/Shougo/dpp-ext-toml')
call vimrc#git#use('https://github.com/Shougo/dpp-ext-lazy')
call vimrc#git#use('https://github.com/Shougo/dpp-protocol-git')
let s:denopsrc = expand('$VIMDIR/local/rc/denops.vim')
if getftype(s:denopsrc) ==# 'file'
  " g:denops#deno等を設定するのを想定
  execute 'source' s:denopsrc
endif
call dpp#make_state(g:vimrc#dpp_base, expand('$VIMDIR/conf/dpp.ts'))
" Auto exit after dpp#make_state()
let g:vimrc#dpp_make_state = v:true
source $VIMDIR/conf/fallback.vim

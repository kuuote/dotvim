set runtimepath^=/data/vim/repos/github.com/vim-denops/denops.vim
set runtimepath^=/data/vim/repos/github.com/Shougo/dpp-ext-toml
set runtimepath^=/data/vim/repos/github.com/Shougo/dpp-ext-lazy
set runtimepath^=/data/vim/repos/github.com/Shougo/dpp-protocol-git
let s:denopsrc = expand('$MYVIMDIR/local/rc/denops.vim')
if getftype(s:denopsrc) ==# 'file'
  " g:denops#deno等を設定するのを想定
  execute 'source' s:denopsrc
endif
call dpp#make_state(g:vimrc#dpp_base, expand('$MYVIMDIR/conf/dpp.ts'))
" Auto exit after dpp#make_state()
let g:vimrc#dpp_make_state = v:true
source $MYVIMDIR/conf/fallback.vim

let $VIMDIR = expand('<sfile>:p:h')
set runtimepath^=$VIMDIR
set runtimepath^=/data/vim/repos/github.com/Shougo/dpp.vim
set runtimepath^=/data/vim/repos/github.com/vim-denops/denops.vim
let s:dpp_base = '/tmp/dpp'
autocmd User DenopsReady
      \ call dpp#make_state(s:dpp_base, $VIMDIR .. '/conf/dpp.ts')

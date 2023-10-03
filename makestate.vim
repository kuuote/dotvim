let $VIMDIR = expand('<sfile>:p:h')
set runtimepath^=$VIMDIR
set runtimepath^=/data/vim/repos/github.com/Shougo/dpp.vim
set runtimepath^=/data/vim/repos/github.com/vim-denops/denops.vim
call dpp#make_state('/tmp/dpp', $VIMDIR .. '/conf/dpp.ts')

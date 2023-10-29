call vimrc#git#use('https://github.com/vim-denops/denops.vim')
call vimrc#git#use('https://github.com/Shougo/dpp-ext-toml')
call vimrc#git#use('https://github.com/Shougo/dpp-ext-lazy')
call vimrc#git#use('https://github.com/Shougo/dpp-protocol-git')
call dpp#make_state(g:vimrc#dpp_base, expand('$VIMDIR/conf/dpp.ts'))
" Auto exit after dpp#make_state()
let g:vimrc#dpp_make_state = v:true
source $VIMDIR/conf/fallback.vim

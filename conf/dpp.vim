set runtimepath^=/data/vim/repos/github.com/Shougo/dpp.vim

let g:vimrc#dpp_base = '/tmp/dpp'
if dpp#min#load_state(g:vimrc#dpp_base)
  autocmd vimrc User Dpp:makeStatePost quit!
  source $VIMDIR/conf/makestate.vim
  finish
endif

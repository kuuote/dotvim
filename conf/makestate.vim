if !exists('#dpp')
  call dpp#min#_init()
endif
call vimrc#git#use('https://github.com/Shougo/dpp-ext-toml')
call vimrc#git#use('https://github.com/Shougo/dpp-ext-lazy')
call vimrc#git#use('https://github.com/Shougo/dpp-protocol-git')
autocmd User DenopsReady
      \ call dpp#make_state(g:vimrc#dpp_base, expand('$VIMDIR/conf/dpp.ts'))
" Auto exit after dpp#make_state()
autocmd User Dpp:makeStatePost quit!
let g:vimrc#dpp_make_state = v:true

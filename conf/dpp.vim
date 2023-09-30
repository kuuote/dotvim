set runtimepath^=/data/vim/repos/github.com/Shougo/dpp.vim
set runtimepath^=/data/vim/repos/github.com/vim-denops/denops.vim

let s:cd = expand('<sfile>:p:h')
let s:dpp_base = '/tmp/dpp'
if dpp#min#load_state(s:dpp_base)
  " ./dpp.ts
  autocmd User DenopsReady
        \ call dpp#make_state(s:dpp_base, s:cd .. '/dpp.ts')
  let g:vimrc_dpp_make_state = v:true
  finish
endif

filetype plugin indent on
syntax on

" adhoc hook
for s:plugin in dpp#_plugins
  if has_key(s:plugin, 'hook_add')
    call execute(s:plugin.hook_add->split('\n'), '')
  endif
  if s:plugin.sourced && has_key(s:plugin, 'hook_source')
    call execute(s:plugin.hook_source, '')
  endif
endfor

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
let s:hook_file = '/tmp/inline.vim/' .. ($VIMDIR .. 'dpp_hook.vim')->substitute('/', '_', 'g')
if getftype(s:hook_file) ==# 'file'
  execute 'source' s:hook_file
  finish
else
  let s:inline = []
  for s:plugin in dpp#_plugins
    if has_key(s:plugin, 'hook_add')
      call add(s:inline, s:plugin.hook_add->trim())
    endif
    if s:plugin.sourced && has_key(s:plugin, 'hook_source')
      call execute(s:plugin.hook_source, '')
      call add(s:inline, s:plugin.hook_source->trim())
    endif
  endfor
  call mkdir('/tmp/inline.vim', 'p')
  call writefile(s:inline->join("\n")->split("\n"), s:hook_file)
  execute 'source' s:hook_file
endif

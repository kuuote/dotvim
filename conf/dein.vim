let s:dein_dir = '/data/vim'

let s:dein_repo = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo)
  execute printf('!git clone https://github.com/Shougo/dein.vim %s', s:dein_repo)
endif
let &runtimepath ..= ',' .. s:dein_repo
let g:dein#auto_recache = 1
let g:dein#cache_directory = '/tmp/dein/cache/' .. v:argv[0]

" 共通で使われる要素を先に初期化しておく
let g:vimrc#ddc_sources = []
let g:vimrc#ddc_source_options = {}

let s:conf = '~/.vim/conf/plug.toml'
let s:conf2 = printf('~/.vim/conf/%s/plug.toml', g:vim_type)
if dein#load_state(s:dein_dir)
  let s:profiles = {}
  let s:profiles['coc'] = 0
  let s:profiles['colorscheme'] = 1
  let s:profiles['ddc'] = 1
  let s:profiles['ddu'] = 1
  let s:profiles['filetype'] = 1
  let s:profiles['main'] = 1
  let s:profiles['nvim-lsp'] = 0
  let s:profiles['treesitter'] = 1
  let s:profiles['vim-lsp'] = 1
  let s:enabled_profiles = map(filter(items(s:profiles), 'v:val[1]'), 'v:val[0]')
  let configs = map(copy(s:enabled_profiles), 'printf("%s/.vim/conf/%s.toml", $HOME, v:val)')
  let configs2 = map(copy(s:enabled_profiles), 'printf("%s/.vim/conf/%s/%s.toml", $HOME, g:vim_type, v:val)')

  call dein#begin(s:dein_dir, flatten([g:vimrc, expand('<sfile>'), configs, configs2]))
  for toml in configs
    if getftype(toml) ==# 'file'
      call dein#load_toml(toml)
    endif
  endfor
  for toml in configs2
    if getftype(toml) ==# 'file'
      call dein#load_toml(toml)
    endif
  endfor
  call dein#end()
  call dein#save_state()
endif

call dein#call_hook('source')

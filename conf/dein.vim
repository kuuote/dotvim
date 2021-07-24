let s:dein_dir = '/data/vim'

let s:dein_repo = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo)
  execute printf('!git clone https://github.com/Shougo/dein.vim %s', s:dein_repo)
endif
let &runtimepath ..= ',' .. s:dein_repo
let g:dein#auto_recache = 1
let g:dein#cache_directory = '/tmp/dein/cache/' .. g:vim_type


let s:conf = '~/.vim/conf/plug.toml'
let s:conf2 = printf('~/.vim/conf/%s/plug.toml', g:vim_type)
if dein#load_state(s:dein_dir)
  let s:profiles = [
  \ 'colorscheme',
  \ 'main',
  \ 'vim-lsp',
  \ ]
  let configs = map(copy(s:profiles), 'printf("%s/.vim/conf/%s.toml", $HOME, v:val)')
  let configs2 = map(copy(s:profiles), 'printf("%s/.vim/conf/%s/%s.toml", $HOME, g:vim_type, v:val)')

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

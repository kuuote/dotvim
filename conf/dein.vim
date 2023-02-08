let s:dein_dir = '/data/vim'

let s:dein_repo = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo)
  execute printf('!git clone https://github.com/Shougo/dein.vim %s', s:dein_repo)
endif
let &runtimepath ..= ',' .. s:dein_repo
let g:dein#auto_recache = 1
let g:dein#install_check_diff = v:true
let g:dein#install_progress_type = 'floating'
let g:dein#cache_directory = '/tmp/dein/cache/' .. v:argv[0]

" 事前に定義しておく必要があるものとか
let g:vimrc#ddc_sources = []
let g:vimrc#ddc_source_options = {}
set rtp+=/data/vim/repos/github.com/tani/vim-artemis

" 気分で変えていくぞ
let g:vim_ui_select = [
\   'none',
\   'ddu.vim',
\   'fzyselect.vim',
\   'dressing_fzf',
\   'dressing_fzf_lua',
\   'dressing_telescope',
\ ][3]

let s:inline_tmp = '/tmp/vimrc_inline/'

let s:conf = '~/.vim/conf/plug.toml'
let s:conf2 = printf('~/.vim/conf/%s/plug.toml', g:vim_type)
if !empty($FORCE_DEIN_RECACHE) || dein#load_state(s:dein_dir)
  call delete(s:inline_tmp, 'rf')
  call mkdir(s:inline_tmp, 'p')
  let s:profiles = {}
  let s:profiles['coc'] = 0
  let s:profiles['colorscheme'] = 1
  let s:profiles['ddc'] = 1
  let s:profiles['ddu'] = 1
  let s:profiles['filetype'] = 1
  let s:profiles['main'] = 1
  let s:profiles['treesitter'] = 1
  let s:profiles['vim-lsp'] = 1
  if 1
    if has('nvim')
      let s:profiles['nvim-lsp'] = 1
      let s:profiles['vim-lsp'] = 0
    endif
  endif
  if has('nvim')
    let s:profiles['cmp'] = 1
  endif
  let s:enabled_profiles = map(filter(items(s:profiles), 'v:val[1]'), 'v:val[0]')
  let configs = map(copy(s:enabled_profiles), 'printf("%s/.vim/conf/%s.toml", $HOME, v:val)')
  let configs2 = map(copy(s:enabled_profiles), 'printf("%s/.vim/conf/%s/%s.toml", $HOME, g:vim_type, v:val)')

  call dein#begin(s:dein_dir, [g:vimrc, expand('<sfile>')])
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

" auto recache時には働いてほしくないのでここ
let g:dein#enable_notification = v:true

if !empty($plug)
  " $plugに何かセットされてたらカレントディレクトリをruntimepathの先頭に置く
  let &runtimepath = printf('%s,%s', getcwd(), &runtimepath)
endif

lua pcall(require, 'impatient')

let hook_source_cache = s:inline_tmp .. v:progname .. 'hook_source.vim'
if !filereadable(hook_source_cache)
  let lines = []
  " from dein#util#_call_hook
  let plugins = filter(dein#util#_tsort(
        \ values(dein#get())),
        \ { _, val ->
        \    val.sourced && has_key(val, 'hook_source') && isdirectory(val.path)
        \    && (!has_key(val, 'if') || eval(val.if))
        \ })
  for p in plugins
    call extend(lines, split(p.hook_source, "\n"))
  endfor
  call writefile(lines, hook_source_cache)
endif
" call dein#call_hook('source')
execute 'source' hook_source_cache

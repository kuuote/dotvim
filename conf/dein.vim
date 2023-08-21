let s:dein_dir = '/data/vim'

let s:dein_repo = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo)
  execute printf('!git clone https://github.com/Shougo/dein.vim %s', s:dein_repo)
endif
let &runtimepath ..= ',' .. s:dein_repo
let g:dein#auto_recache = 1
let g:dein#install_check_diff = v:true
let g:dein#install_progress_type = 'floating'
let g:dein#cache_directory = '/tmp/dein/cache/' .. ($vimprofile ?? v:argv[0])
let g:dein#lazy_rplugins = v:true

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
\ ][1]

let s:inline_tmp = '/tmp/vimrc_inline/'

if !empty($FORCE_DEIN_RECACHE) || dein#load_state(s:dein_dir)
  let lsp = [
  \   'coc',
  \   'vim-lsp',
  \   'nvim-lsp',
  \   'lspoints',
  \ ][3]

  call delete(s:inline_tmp, 'rf')
  call mkdir(s:inline_tmp, 'p')
  let s:profiles = {}
  let s:profiles['colorscheme'] = 1
  let s:profiles['ddc'] = 1
  let s:profiles['ddu'] = 1
  " denoの依存
  " dotvimに埋めてるdenops系のあれこれの設定でimportしたい
  " 一々依存を更新するのはおつらいのでこうする
  let s:profiles['deno'] = 1
  let s:profiles['filetype'] = 1
  let s:profiles[lsp] = 1
  let s:profiles['main'] = 1
  let s:profiles['treesitter'] = 1
  if has('nvim')
    let s:profiles['cmp'] = 1
  endif
  let s:profiles['x'] = 1 " 手元で試してるあれこれ置き場
  let s:profiles['z'] = 1 " プラグインじゃないけど管理したいやつ
  let s:enabled_profiles = map(filter(items(s:profiles), 'v:val[1]'), 'v:val[0]')
  let configs = map(copy(s:enabled_profiles), 'printf("%s/conf/%s.toml", $DOTVIM, v:val)')
  let configs2 = map(copy(s:enabled_profiles), 'printf("%s/conf/%s/%s.toml", $DOTVIM, g:vim_type, v:val)')

  call dein#begin(s:dein_dir, [$VIMRC, expand('<sfile>')])
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
  for s in glob('$DOTVIM/conf/recache/**/*.vim', v:true, v:true)
    execute 'source' s
  endfor
  call dein#end()
  call dein#save_state()
endif

" auto recache時には働いてほしくないのでここ
let g:dein#enable_notification = v:true

if !empty($plug)
  " $plugに何かセットされてたらカレントディレクトリをruntimepathの先頭に置く
  let &runtimepath = printf('%s,%s', getcwd(), &runtimepath)
  if getftype('/tmp/templug') == 'dir' && empty($noautoload)
    " templugの下に何かあったらruntimepathの先頭に置く
    let s:plugins = glob('/tmp/templug/*', 1, 1)
    if !empty(s:plugins)
      let &runtimepath = s:plugins->join(',') .. ',' .. &runtimepath
    endif
    " お掃除コマンドも定義しておく
    command! TemplugClean call delete('/tmp/templug', 'rf')
  endif
endif

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
    " suppress duplicate hook call
    call extend(lines, [printf('let s:plugin = dein#get("%s")', p.name)])
    call extend(lines, ['let s:plugin.hook_source = ""'])
  endfor
  call writefile(lines, hook_source_cache)
endif
" call dein#call_hook('source')
execute 'source' hook_source_cache

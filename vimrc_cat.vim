" vim: fdm=marker
" Startup {{{

" Rewrite $MYVIMRC when using vim in :terminal
let $MYVIMRC = expand("<sfile>")

set encoding=utf-8

let mapleader = ","

" Delete autocommands
augroup vimrc
  autocmd!
augroup vimrc_sound
  autocmd!
augroup END

" }}}

" Error catcher {{{
" silent!したいけどエラーは見たいので

let g:vimrc_errors = []
function! s:catch(args) abort
  try
    execute a:args
  catch
    call vimrc#add_exception()
  endtry
endfunction

command! -nargs=* Catch call s:catch("<args>")

" }}}

" Plugin {{{

if !v:vim_did_enter
  let s:minpac = fnamemodify("~/.vim/pack/minpac/opt/minpac", ":p")

  if !isdirectory(s:minpac) && executable("git")
    call mkdir(fnamemodify(s:minpac, ":h"), "p")
    execute "!git clone https://github.com/k-takata/minpac.git" s:minpac
  endif
  packadd minpac

  if exists("*minpac#init")
    call minpac#init()
    call minpac#add("k-takata/minpac", {"type": "opt"})

" cat.vim: ~/.vim/scripts/plug/appearance.vim {{{ 
call minpac#add('itchyny/lightline.vim')
call minpac#add('unblevable/quick-scope')
call minpac#add('mhinz/vim-signify')
" }}}
" cat.vim: ~/.vim/scripts/plug/appearance/colorizer.vim {{{ 
call minpac#add('lilydjwg/colorizer', {'type': 'opt'})

let g:colorizer_startup = v:false

" こちらはcolorizer側で上書きされる
nnoremap <silent> <Plug>Colorizer :<C-u>packadd colorizer<CR>:ColorToggle<CR>

let g:colorizer_nomap = v:true
" あちらでマップされるものと同じ
nmap <Leader>tc <Plug>Colorizer
" }}}
" cat.vim: ~/.vim/scripts/plug/colors.vim {{{ 
" :colorschemeはoptを見てくれるので便利
call minpac#add('aereal/vim-colors-japanesque', {'type': 'opt'})
call minpac#add('ajgrf/parchment', {'type': 'opt'})
call minpac#add('caksoylar/vim-mysticaltutor', {'type': 'opt'})
call minpac#add('cocopon/iceberg.vim', {'type': 'opt'})
call minpac#add('fcpg/vim-orbital', {'type': 'opt'})
call minpac#add('freeo/vim-kalisi', {'type': 'opt'})
call minpac#add('habamax/vim-colors-defminus', {'type': 'opt'})
call minpac#add('junegunn/seoul256.vim', {'type': 'opt'})
call minpac#add('lifepillar/vim-solarized8', {'type': 'opt'})
call minpac#add('liuchengxu/space-vim-theme', {'type': 'opt'})
call minpac#add('machakann/vim-colorscheme-snowtrek', {'type': 'opt'})
call minpac#add('morhetz/gruvbox', {'type': 'opt'})
call minpac#add('nightsense/seabird', {'type': 'opt'})
call minpac#add('reedes/vim-colors-pencil', {'type': 'opt'})
call minpac#add('romainl/Apprentice', {'type': 'opt'})
call minpac#add('tomasr/molokai', {'type': 'opt'})
call minpac#add('toupeira/vim-desertink', {'type': 'opt'})
call minpac#add('vim-scripts/moria', {'type': 'opt'})
call minpac#add('vim-scripts/summerfruit256.vim', {'type': 'opt'})
call minpac#add('whatyouhide/vim-gotham', {'type': 'opt'})
call minpac#add('yasukotelin/shirotelin', {'type': 'opt'})
call minpac#add('yous/vim-open-color', {'type': 'opt'})
call minpac#add('yuttie/hydrangea-vim', {'type': 'opt'})
" }}}
" cat.vim: ~/.vim/scripts/plug/edit.vim {{{ 
call minpac#add('machakann/vim-sandwich')
" }}}
" cat.vim: ~/.vim/scripts/plug/edit/caw.vim {{{ 
call minpac#add('tyru/caw.vim', {'type': 'opt'})

nmap <SID>prefix <Plug>(caw:prefix)
xmap <SID>prefix <Plug>(caw:prefix)

nnoremap <script> gc :<C-u>packadd caw.vim<CR><SID>prefix
xnoremap <script> gc :<C-u>packadd caw.vim<CR><SID>prefix
" }}}
" cat.vim: ~/.vim/scripts/plug/edit/eskk.vim {{{ 
call minpac#add('tyru/eskk.vim')

"use dotfiles dictionary
let g:eskk#dictionary = {'path':$HOME .. "/.vim/tmp/.skk-jisyo"}
let g:eskk#large_dictionary = {'path': '~/.skk/SKK-JISYO.L', 'sorted': 0, 'encoding': 'euc-jp'}
"enable eskk in 'jf'
imap jf <Plug>(eskk:enable)
cmap jf <Plug>(eskk:enable)

"skk-search shortcut
nmap <Space>/ :<C-u>set nohlsearch<CR>/jf
nmap <Space>? :<C-u>set nohlsearch<CR>?jf

"sticky key
augroup vimrc
  autocmd User eskk-enable-post lnoremap <buffer> <expr> : eskk#filter(eskk#util#key2char(eskk#get_mode() == "ascii" ? ":" : ";"))
augroup END

"register alphabet table

function! s:eskk_initialize_pre()
  let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
  call t.add_map('z ', '　')
  call eskk#register_mode_table('hira', t)
endfunction

augroup vimrc
  autocmd User eskk-initialize-pre call s:eskk_initialize_pre()
augroup END

function! s:eskkfunc(seq)
  call eskk#enable()
  call feedkeys(a:seq, 'n')
endfunction

function! s:eskkmap(mode, seq)
  exe a:mode .. 'noremap <buffer> <silent> ' .. a:seq .. ' :<C-u>call <SID>eskkfunc("' .. a:seq ..  '")<CR>'
endfunction

function! s:my_eskk_func()
  "オリジナルのSKK-i-searchモードみたいな感じで
  nmap <buffer> <silent> <Space>s :<C-u>set nohlsearch<CR>/jf
  nmap <buffer> <silent> <Space>r :<C-u>set nohlsearch<CR>?jf
  "よく使うモーションと同時にeskkを起動
  call s:eskkmap('n', 'A')
  call s:eskkmap('n', 'C')
  call s:eskkmap('n', 'I')
  call s:eskkmap('n', 'O')
  call s:eskkmap('n', 'a')
  call s:eskkmap('n', 'cG')
  call s:eskkmap('n', 'cc')
  call s:eskkmap('n', 'i')
  call s:eskkmap('n', 'o')
  call s:eskkmap('v', 'I')
  call s:eskkmap('v', 'c')
  "個人的によく使うやつ、wipeout
  nnoremap <buffer> <silent> w :<C-u>call <SID>eskkfunc('ggcG')<CR>
  "基本的にs使わないので押しづらいCの代わり
  nnoremap <buffer> <silent> s :<C-u>call <SID>eskkfunc('C')<CR>
endfunction

command! MyEskk :call <SID>my_eskk_func()
" }}}
" cat.vim: ~/.vim/scripts/plug/edit/lexima.vim {{{ 
call minpac#add('cohama/lexima.vim')
let g:lexima_nvim_accept_pum_with_enter = 0
" }}}
" cat.vim: ~/.vim/scripts/plug/edit/vim-sonictemplate.vim {{{ 
call minpac#add('mattn/vim-sonictemplate')

let g:sonictemplate_vim_template_dir = [$HOME .. "/.vim/template"]
imap <Tab> <Plug>(sonictemplate-postfix)
autocmd vimrc FileType stpl setlocal noexpandtab
" }}}
" cat.vim: ~/.vim/scripts/plug/file.vim {{{ 
call minpac#add('lambdalisue/suda.vim')
call minpac#add('gotchane/vim-git-commit-prefix')
" }}}
" cat.vim: ~/.vim/scripts/plug/file/2html.vim {{{ 
let g:html_number_lines=1
let g:html_use_css=1
let g:html_ignore_folding=1
" }}}
" cat.vim: ~/.vim/scripts/plug/file/fern.vim {{{ 
call minpac#add('lambdalisue/fern.vim')

nnoremap <Space>f :<C-u>Fern . -drawer -toggle -reveal=%<CR>

function s:ask_path()
  let path = input("Path:", expand("%:p:h"))
  exe printf("Fern %s -drawer -toggle -reveal=%%", path)
endfunction

nnoremap <Space>F :<C-u>call <SID>ask_path()<CR>

function! s:rc()
  noremap <buffer> <nowait> q <C-w>p
  nmap <buffer> <CR> <Plug>(fern-action-open)
  noremap <buffer> <RightMouse> <LeftRelease>
  nmap <buffer> <RightRelease> h
  nmap <buffer> <LeftRelease> l
  setlocal foldmethod=marker
endfunction

function s:close_fern()
  "コマンドラインウィンドウでこれ走ると厄介なことになる
  if &filetype == "fern" || !empty(getcmdwintype())
    return
  endif
  for b in tabpagebuflist()
    if getbufvar(b, "&filetype") == "fern"
      execute "bdelete " .. b
    endif
  endfor
endfunction

augroup vimrc
  autocmd FileType fern call s:rc()
  "WinEnterだとgetcmdwintype()が機能しない
  autocmd BufEnter * call s:close_fern()
augroup END
" }}}
" cat.vim: ~/.vim/scripts/plug/file/gina.vim {{{ 
call minpac#add('lambdalisue/gina.vim')

packadd gina.vim

nnoremap gl :<C-u>Gina log<CR>
nnoremap gs :<C-u>Gina status<CR>

try
  call gina#custom#mapping#nmap(
  \ 'status', 'cm',
  \ ':<C-u>Gina commit -v --opener=tabedit<CR>',
  \ {'noremap': 1, 'silent': 1},
  \)

  " HEAD表示なくてもおk
  call gina#custom#mapping#nmap(
  \ 'status', 's',
  \ '<Plug>(gina-patch-oneside-tab)',
  \ {'silent': 1, 'nowait': 1},
  \)
catch
  call vimrc#add_exception()
endtry

function! s:preview_apply(text, ft) abort
  if !bufexists(b:prbuf)
    return
  endif
  call setbufvar(b:prbuf, "&ft", a:ft)
  call deletebufline(b:prbuf, 1, "$")
  call setbufline(b:prbuf, 1, a:text)
endfunction

let s:preview_job = -1
let s:preview_acc = []

function! s:preview_cb(ch, msg) abort
  call add(s:preview_acc, a:msg)
endfunction

function! s:preview_change() abort
  " Gitのメッセージ位置を取ってdiffするかファイルを直接読むかを決める
  let lines = getline(1, "$")
  let nostaged = index(lines, "Changes not staged for commit:")
  let untracked = index(lines, "Untracked files:")
  let line = getline(".")
  " Ginaはファイル部分をエスケープしてくれているので利用する
  if stridx(line, "\<Esc>") != -1
    let linepos = line(".")
    if untracked != -1 && linepos > untracked
      " untrackedより先はファイルを直接開く
      try
        " エスケープシーケンスを利用して切り出し
        let line = substitute(line, "\\v.*\<Esc>\\[\\d+m(.*)\<Esc>.*", "\\1", "")
        if line =~ "/$"
          let res = readdir(line)
        else
          let res = readfile(line)
        endif
        call s:preview_apply(res, "text")
      catch
        echo [v:exception, v:throwpoint]
        call add(g:vimrc_errors, [v:exception, v:throwpoint])
      endtry
    else
      " もうちょっと上手くできた気がするけど面倒だし当分は放置
      let line = substitute(line, "\\v[^:]*:\\s*", "", "")
      let line = substitute(line, "\\v\<Esc>.*", "", "")
      let opt = (nostaged != -1 && linepos > nostaged) ? "" : "--staged"
      silent! call job_stop(s:preview_job, "kill")
      let s:preview_acc = []
      " TODO:neovimでは動かんのでそのうちなんとかする
      let preview_job = job_start(split(printf("git diff %s %s", opt, line)), {
      \ "close_cb": {ch->s:preview_apply(s:preview_acc, "diff")},
      \ "out_cb": funcref("s:preview_cb"),
      \ })
    endif
  endif
endfunction

function! s:preview_open() abort
  execute "lcd" system("git rev-parse --show-toplevel")
  let curwin = win_getid()
  new
  let prbuf = bufnr("%")
  setlocal buftype=nofile bufhidden=hide noswapfile
  call win_gotoid(curwin)
  let b:prbuf = prbuf
  autocmd CursorMoved <buffer> call s:preview_change()
endfunction

augroup vimrc
  autocmd vimrc FileType gina-status nnoremap <buffer> pr :<C-u>call <SID>preview_open()<CR>
  autocmd vimrc FileType gina-status setlocal number relativenumber
augroup END
" }}}
" cat.vim: ~/.vim/scripts/plug/file/qfixhowm.vim {{{ 
" qfixhowm行儀が悪いので透過的に遅延ロードさせる
call minpac#add('fuenor/qfixhowm', {'type': 'opt'})

let s:leader = get(g:, "mapleader", "\\")
let s:map = "g" .. (empty(s:leader) ? "\\" : s:leader)

" g<Leader>が押されたらロードしてマッピングを送りなおす
function! s:load() abort
  packadd qfixhowm
  execute "unmap" s:map
  call feedkeys(s:map)
endfunction

nnoremap <silent> <nowait> g<Leader> :<C-u>call <SID>load()<CR>
" }}}
" cat.vim: ~/.vim/scripts/plug/file/vaffle.vim {{{ 
call minpac#add('cocopon/vaffle.vim')

"shortcut to vaffle in current directory
"nnoremap <Space>d :Vaffle %:p:h<Enter>
" let g:vaffle_show_hidden_files=1
let g:vaffle_auto_cd=0

function! s:customize_vaffle_mappings() abort
  " Customize key mappings here
  nmap <buffer> <Bslash> <Plug>(vaffle-open-root)
  nmap <buffer> K        <Plug>(vaffle-mkdir)
  nmap <buffer> N        <Plug>(vaffle-new-file)
  nor  <buffer> <silent> <Space>cd :silent :execute printf('lcd %s', fnameescape(vaffle#buffer#extract_path_from_bufname(bufname("%"))))<CR>:echo "change directory"<CR>
  nor  <buffer> <expr> y setreg(v:register, strpart(expand("%"), 11) . "/" . expand("<cfile>"))
endfunction

augroup vimrc
  autocmd FileType vaffle call s:customize_vaffle_mappings()
  " autocmd FileType vaffle setlocal foldmethod=marker
augroup END
" }}}
" cat.vim: ~/.vim/scripts/plug/filetype/go.vim {{{ 
call minpac#add('mattn/vim-goimports', {'type': 'opt'})

function! s:load_go() abort
  packadd vim-goimports
  doautocmd FileType go
endfunction

autocmd FileType go ++once call s:load_go()
" }}}
" cat.vim: ~/.vim/scripts/plug/filetype/lisp.vim {{{ 
call minpac#add('guns/vim-sexp', {'type': 'opt'})

" FIXME:filetype動かないのでは？
autocmd FileType clojure,lisp,scheme ++once packadd vim-sexp

let g:sexp_mappings = {}

" barfage
let g:sexp_mappings.sexp_emit_head_element = "<Leader>j"
let g:sexp_mappings.sexp_emit_tail_element = "<Leader>k"
" slurpage
let g:sexp_mappings.sexp_capture_next_element = "<Leader>l"
let g:sexp_mappings.sexp_capture_prev_element = "<Leader>h"

let g:sexp_enable_insert_mode_mappings = v:false
" }}}
" cat.vim: ~/.vim/scripts/plug/filetype/markdown.vim {{{ 
call minpac#add('previm/previm', {'type': 'opt'})

let g:previm_open_cmd = "firefox"

function! s:load_previm() abort
  packadd previm
  execute "doautocmd FileType" expand("<amatch>")
  PrevimWipeCache
endfunction

autocmd FileType *{mkd,markdown,rst,textile,asciidoc}* ++once call <SID>load_previm()
" }}}
" cat.vim: ~/.vim/scripts/plug/filetype/zsh.vim {{{ 
call minpac#add('Valodim/vim-zsh-completion')
" }}}
" cat.vim: ~/.vim/scripts/plug/lsp.vim {{{ 
call minpac#add('hrsh7th/vim-vsnip', {'type': 'opt'})
call minpac#add('hrsh7th/vim-vsnip-integ', {'type': 'opt'})
call minpac#add('mattn/vim-lsp-settings', {'type': 'opt'})
call minpac#add('prabirshrestha/async.vim', {'type': 'opt'})
call minpac#add('prabirshrestha/asyncomplete.vim', {'type': 'opt'})
call minpac#add('prabirshrestha/asyncomplete-lsp.vim', {'type': 'opt'})
call minpac#add('prabirshrestha/vim-lsp', {'type': 'opt'})

function! s:load_lsp() abort
  packadd vim-vsnip
  packadd vim-vsnip-integ
  packadd vim-lsp-settings
  packadd async.vim
  packadd asyncomplete.vim
  packadd asyncomplete-lsp.vim
  packadd vim-lsp
  execute "doau FileType" expand("<amatch>")
endfunction

autocmd FileType go,python,rust ++once call s:load_lsp()

" see https://mattn.kaoriya.net/software/vim/20191231213507.htm
" とりあえずログ吐いておく
let g:lsp_log_verbose = v:true
" HDDアクセスが遅いのでメモリに吐く
let g:lsp_log_file = "/tmp/lsp.log"
if !v:vim_did_enter && !filewritable(g:lsp_log_file)
  unlet g:lsp_log_file
endif

let g:lsp_diagnostics_enabled = v:true
let g:lsp_diagnostics_echo_cursor = v:true

" noinsertやnoselectはふべん
let g:asyncomplete_auto_completeopt = 0

function! s:on_lsp() abort
  setlocal omnifunc=lsp#complete
  " グローバルで切ったのでここで代わりに
  setlocal completeopt=menuone,noinsert,noselect
  inoremap <expr> <CR> pumvisible() ? "\<c-y>\<CR>" : "\<CR>"
  nmap <buffer> gd <Plug>(lsp-definition)
  nmap <buffer> e <Plug>(lsp-hover)
endfunction

autocmd vimrc User lsp_buffer_enabled call s:on_lsp()

" vim-lsp-settings
let g:lsp_settings = {
\ "bash-language-server": {"disabled": v:true},
\ "vim-language-server": {"disabled": v:true},
\}
" }}}
" cat.vim: ~/.vim/scripts/plug/movement/easymotion.vim {{{ 
call minpac#add('easymotion/vim-easymotion', {'type': 'opt'})

let g:EasyMotion_leader_key = ','
let g:EasyMotion_keys = 'asdfjkl;zxcvm,./'

nmap <SID>s2. <Plug>(easymotion-s2)
nmap <SID>s. <Plug>(easymotion-s)

nnoremap <script> w :<C-u>packadd vim-easymotion<CR><SID>s2.
nnoremap <script> e :<C-u>packadd vim-easymotion<CR><SID>s.
function! s:highlight() abort
  silent hi link EasyMotionTarget Constant
  silent hi link EasyMotionTarget2First Identifier
  silent hi link EasyMotionTarget2Second Statement
endfunction

autocmd vimrc ColorScheme call s:highlight()
" }}}
" cat.vim: ~/.vim/scripts/plug/selector.vim {{{ 
call minpac#add('liuchengxu/vim-clap')
" }}}
" cat.vim: ~/.vim/scripts/plug/selector/fz.vim {{{ 
if executable("gof")
  call minpac#add('mattn/vim-fz', {'type': 'opt'})
  packadd vim-fz
  nnoremap <silent> <Space>yt :<C-u>call fz#sonictemplate#run()<CR>
endif
" }}}
" cat.vim: ~/.vim/scripts/plug/selector/leaderf.vim {{{ 
if has("python3")
  call minpac#add('Yggdroot/LeaderF', {'type': 'opt'})
  call minpac#add('tamago324/LeaderF-filer', {'type': 'opt'})
  packadd LeaderF
  packadd LeaderF-filer
  nnoremap <Leader>F :<C-u>LeaderfFiler<CR>
endif
" }}}
" cat.vim: ~/.vim/scripts/plug/selector/vim-candle.vim {{{ 
call minpac#add('hrsh7th/vim-candle')

autocmd vimrc User candle#initialize :

autocmd vimrc User candle#start call s:on_candle_start()
function! s:on_candle_start()
  nnoremap <silent><buffer> k     :<C-u>call candle#mapping#cursor_move(-1)<CR>
  nnoremap <silent><buffer> j     :<C-u>call candle#mapping#cursor_move(1)<CR>
  nnoremap <silent><buffer> K     :<C-u>call candle#mapping#cursor_move(-10)<CR>
  nnoremap <silent><buffer> J     :<C-u>call candle#mapping#cursor_move(10)<CR>
  nnoremap <silent><buffer> gg    :<C-u>call candle#mapping#cursor_top()<CR>
  nnoremap <silent><buffer> G     :<C-u>call candle#mapping#cursor_bottom()<CR>
  nnoremap <silent><buffer> -     :<C-u>call candle#mapping#toggle_select()<CR>
  nnoremap <silent><buffer> *     :<C-u>call candle#mapping#toggle_select_all()<CR>
  nnoremap <silent><buffer> i     :<C-u>call candle#mapping#input_open()<CR>
  nnoremap <silent><buffer> a     :<C-u>call candle#mapping#input_open()<CR>
  nnoremap <silent><buffer> <Tab> :<C-u>call candle#mapping#choose_action()<CR>
  nnoremap <silent><buffer> <C-l> :<C-u>call candle#mapping#restart()<CR>

  nnoremap <silent><buffer> <CR>  :<C-u>call candle#mapping#action('default')<CR>
  nnoremap <silent><buffer> s     :<C-u>call candle#mapping#action('split')<CR>
  nnoremap <silent><buffer> v     :<C-u>call candle#mapping#action('vsplit')<CR>
  nnoremap <silent><buffer> d     :<C-u>call candle#mapping#action('delete')<CR>
endfunction
autocmd vimrc User candle#input#start call s:on_candle_input_start()
function! s:on_candle_input_start()
  cnoremap <silent><buffer> <Tab> <Esc>:<C-u>call candle#mapping#choose_action()<CR>
  cnoremap <silent><buffer> <C-y> <Esc>:<C-u>call candle#mapping#action('default')<CR>
  cnoremap <silent><buffer> <C-p> <Esc>:<C-u>call candle#mapping#cursor_move(-1) \| call candle#mapping#input_open()<CR>
  cnoremap <silent><buffer> <C-n> <Esc>:<C-u>call candle#mapping#cursor_move(+1) \| call candle#mapping#input_open()<CR>
endfunction

function! s:mru()
  call candle#start({
        \        'mru_file': {
        \          'ignore_patterns': map(
        \            range(1, tabpagewinnr(tabpagenr(), '$')),
        \            { i, winnr -> fnamemodify(bufname(winbufnr(winnr)), ':p') }
        \          )
        \        }
        \    })
endfunction

nnoremap <Space>o :<C-u>call <SID>mru()<CR>
" }}}
" cat.vim: ~/.vim/scripts/plug/textobj.vim {{{ 
call minpac#add('kana/vim-textobj-entire')
call minpac#add('kana/vim-textobj-user')
call minpac#add('sgur/vim-textobj-parameter')
" }}}
" cat.vim: ~/.vim/scripts/plug/util.vim {{{ 
call minpac#add('tennashi/trunner.vim')
call minpac#add('thinca/vim-ambicmd')
call minpac#add('thinca/vim-localrc')
call minpac#add('thinca/vim-themis')
call minpac#add('tweekmonster/helpful.vim')
call minpac#add('tyru/capture.vim')
call minpac#add('tyru/sync-term-cwd.vim')
call minpac#add('vim-jp/vital.vim')
" }}}
" cat.vim: ~/.vim/scripts/plug/util/notify-changed.vim {{{ 
call minpac#add('tyru/notify-changed.vim', {'type': 'opt'})
if executable("notify-send")
  packadd notify-changed.vim
endif
" }}}
" cat.vim: ~/.vim/scripts/plug/util/quickrun.vim {{{ 
call minpac#add('thinca/vim-quickrun')

nnoremap <silent> ' :<C-u>QuickRun -outputter multi:quickfix;open_cmd=:popup<CR>

" 都合上一緒に書いてるけどそのうちどっか移す
nnoremap <Space>' :<C-u>call vimrc#qftoggle()<CR>
" }}}
" cat.vim: ~/.vim/scripts/plug/util/watermelon.vim {{{ 
call minpac#add('kuuote/vim-watermelon')

let g:watermelon_shellcomplete = v:true
let g:watermelon_chdir = v:true

autocmd vimrc User Watermelon nnoremap <buffer> <silent> R :<C-u>call watermelon#readrc()<CR>
autocmd vimrc User Watermelon nnoremap <buffer> <silent> W :<C-u>call watermelon#writerc()<CR>
" }}}
" cat.vim: ~/.vim/scripts/plug/vimdoc-ja.vim {{{ 
call minpac#add('vim-jp/vimdoc-ja')

set helplang=ja
" }}}
" cat.vim: ~/.vim/scripts/plug/vimrc.vim {{{ 
nmap <Space>a <Plug>(bookmark-add)
nmap <Space>m <Plug>(bookmark-select)
nnoremap <Space>d :<C-u>call vimrc#selector#filer#openbuf("")<CR>
" }}}
    if has("nvim")
" cat.vim: ~/.vim/scripts/plug.nvim/filetype/python.vim {{{ 
call minpac#add('numirias/semshi', {'type': 'opt'})

function! s:load_python_nvim() abort
  packadd semshi
  silent! UpdateRemotePlugins
  doautocmd FileType python
endfunction

if has("nvim")
  autocmd FileType python ++once call s:load_python_nvim()
endif
" }}}
" cat.vim: ~/.vim/scripts/plug.nvim/selector/denite.vim {{{ 
call minpac#add('Shougo/denite.nvim', {'type': 'opt'})
silent! packadd denite.nvim

" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

function! s:denite_init() abort
  try
    " Change file/rec command.
    call denite#custom#var('file/rec', 'command',
    \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
    " For ripgrep
    " Note: It is slower than ag
    call denite#custom#var('file/rec', 'command',
    \ ['rg', '--files', '--glob', '!.git'])
    " For Pt(the platinum searcher)
    " NOTE: It also supports windows.
    call denite#custom#var('file/rec', 'command',
    \ ['pt', '--follow', '--nocolor', '--nogroup',
    \  (has('win32') ? '-g:' : '-g='), ''])
    " For python script scantree.py
    " Read bellow on this file to learn more about scantree.py
    call denite#custom#var('file/rec', 'command',
    \ ['scantree.py', '--path', ':directory'])

    " Change matchers.
    call denite#custom#source(
    \ 'file_mru', 'matchers', ['matcher/fuzzy', 'matcher/project_files'])
    call denite#custom#source(
    \ 'file/rec', 'matchers', ['matcher/cpsm'])

    " Change sorters.
    call denite#custom#source(
    \ 'file/rec', 'sorters', ['sorter/sublime'])

    " Change default action.
    call denite#custom#kind('file', 'default_action', 'split')

    " Add custom menus
    let s:menus = {}

    let s:menus.zsh = {
    \ 'description': 'Edit your import zsh configuration'
    \ }
    let s:menus.zsh.file_candidates = [
    \ ['zshrc', '~/.config/zsh/.zshrc'],
    \ ['zshenv', '~/.zshenv'],
    \ ]

    let s:menus.my_commands = {
    \ 'description': 'Example commands'
    \ }
    let s:menus.my_commands.command_candidates = [
    \ ['Split the window', 'vnew'],
    \ ['Open zsh menu', 'Denite menu:zsh'],
    \ ['Format code', 'FormatCode', 'go,python'],
    \ ]

    call denite#custom#var('menu', 'menus', s:menus)

    " Ag command on grep source
    call denite#custom#var('grep', 'command', ['ag'])
    call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--vimgrep'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    " Ack command on grep source
    call denite#custom#var('grep', 'command', ['ack'])
    call denite#custom#var('grep', 'default_opts',
    \ ['--ackrc', $HOME.'/.ackrc', '-H', '-i',
    \  '--nopager', '--nocolor', '--nogroup', '--column'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--match'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    " Ripgrep command on grep source
    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--vimgrep', '--no-heading'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    " Pt command on grep source
    call denite#custom#var('grep', 'command', ['pt'])
    call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--nogroup', '--nocolor', '--smart-case'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    " jvgrep command on grep source
    call denite#custom#var('grep', 'command', ['jvgrep'])
    call denite#custom#var('grep', 'default_opts', ['-i'])
    call denite#custom#var('grep', 'recursive_opts', ['-R'])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', [])
    call denite#custom#var('grep', 'final_opts', [])

    " Specify multiple paths in grep source
    "call denite#start([{'name': 'grep',
    "      \ 'args': [['a.vim', 'b.vim'], '', 'pattern']}])

    " Define alias
    call denite#custom#alias('source', 'file/rec/git', 'file/rec')
    call denite#custom#var('file/rec/git', 'command',
    \ ['git', 'ls-files', '-co', '--exclude-standard'])

    call denite#custom#alias('source', 'file/rec/py', 'file/rec')
    call denite#custom#var('file/rec/py', 'command',
    \ ['scantree.py', '--path', ':directory'])

    " Change ignore_globs
    call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
    \ [ '.git/', '.ropeproject/', '__pycache__/',
    \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

    " Custom action
    " Note: lambda function is not supported in Vim8.
    call denite#custom#action('file', 'test',
    \ {context -> execute('let g:foo = 1')})
    call denite#custom#action('file', 'test2',
    \ {context -> denite#do_action(
    \  context, 'open', context['targets'])})
  catch
    call vimrc#add_exception()
  endtry
endfunction

autocmd VimEnter * call s:denite_init()
" }}}
" cat.vim: ~/.vim/scripts/plug.nvim/selector/fzf-preview.vim {{{ 
call minpac#add('yuki-ycino/fzf-preview.vim', {'type': 'opt'})
packadd fzf-preview.vim
packadd gina.vim
try
  call gina#custom#mapping#nmap(
        \ 'status', 'p',
        \ ':FzfPreviewGitStatus<CR>',
        \ {'silent': 1, 'nowait': 1},
        \)
catch
  call vimrc#add_exception()
endtry
" }}}
    else
    endif
  endif

  " 現在のディレクトリがプラグインであればrtpに加える
  for dir in [
  \ "./autoload",
  \ "./colors",
  \ "./ftplugin",
  \ "./indent",
  \ "./plugin",
  \ "./syntax",
  \ ]
    if isdirectory(dir)
      set rtp^=.
      break
    endif
  endfor
endif

" }}}

" cat.vim: ~/.vim/scripts/config/autocmd.vim {{{ 
if has('unnamedplus')
  "ヤンクとかペースト時にOSのクリップボードを使ってくれるやつ
  set clipboard=unnamedplus
elseif executable("xclip")
  "X11有効になってないVim使ってるときにxclipがあればそれにヤンクしたものを流す
  autocmd vimrc TextYankPost * call system("xclip -selection clipboard", @")
endif

function! s:chmod(file) abort
  let perm = getfperm(a:file)
  let newperm = printf("%sx%sx%sx", perm[0:1], perm[3:4], perm[6:7])
  if perm != newperm
    call setfperm(a:file, newperm)
  endif
endfunction

" シバン付いてるファイルに実行権限を与える
autocmd vimrc BufWritePost * if getline(1) =~ "^#!" | call s:chmod(expand("<afile>")) | endif

" Automatically create missing directories {{{
" copied from https://github.com/lambdalisue/dotfiles/blob/master/nvim/init.vim
function! s:auto_mkdir(dir, force) abort
  if empty(a:dir) || a:dir =~# '^\w\+://' || isdirectory(a:dir) || a:dir =~# '^suda:'
      return
  endif
  if !a:force
    echohl Question
    call inputsave()
    try
      let result = input(
            \ printf('"%s" does not exist. Create? [y/N]', a:dir),
            \ '',
            \)
      if empty(result)
        echohl WarningMsg
        echo 'Canceled'
        return
      endif
    finally
      call inputrestore()
      echohl None
    endtry
  endif
  call mkdir(a:dir, 'p')
endfunction
autocmd vimrc BufWritePre *
      \ call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
" }}}
" }}}
" cat.vim: ~/.vim/scripts/config/autocmd/sound.vim {{{ 
let s:keywave = expand("~/.vim/wav/kbd.wav")
let s:vimrc_sound_cursor = [1, 1]
function! s:keysound() abort
  let c = [line("."), col(".")]
  if s:vimrc_sound_cursor != c
    call vimrc#play(s:keywave)
    let s:vimrc_sound_cursor = c
  endif
endfunction

augroup vimrc_sound
  autocmd CursorMoved * call s:keysound()
  autocmd CursorMovedI * call s:keysound()

  let s:del_sounds = glob("~/.vim/wav/delete/*.wav", v:true, v:true)

  function! s:delsound() abort
    if v:event.operator !~ "[cd]"
      return
    endif
    call vimrc#play(s:del_sounds[float2nr(1.0 * len(s:del_sounds) * vimrc#rand() / pow(2, 32))])
  endfunction

  autocmd TextYankPost * call s:delsound()

  " ソフトウェアたるもの起動音はもちろん必要だよね
  autocmd VimEnter * call vimrc#play(expand("~/.vim/wav/pc98.wav"))

augroup END
" }}}
" cat.vim: ~/.vim/scripts/config/colors.vim {{{ 
"xterm互換端末以外は使わないという強い意志
if !has("nvim")
  set term=xterm-256color
endif
"ターミナルでもGUIと同じカラースキームを使う
set termguicolors

" set transparent
nnoremap <Space>tp :<C-u>hi Normal ctermbg=NONE guibg=NONE<CR>

" persistent colorscheme selector {{{

let s:this = expand("<sfile>")

" Derived from fzf.vim and vim-clap
function! s:colors() abort
  let colors = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
  if has('packages')
    let colors += split(globpath(&packpath, 'pack/*/opt/*/colors/*.vim'), "\n")
  endif
  return sort(map(colors, "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"))
endfunction

"save setting to the file
function! s:save() abort
  call vimrc#selector#close()
  let f = []
  call add(f, "let g:colors_name = " .. string(s:cs))
  call add(f, "set background=" .. s:bg)
  let tmpdir = fnamemodify(s:this, ":p:h") .. "/tmp"
  call mkdir(tmpdir, "p")
  call writefile(f, tmpdir .. "/colors.vim")
  echo "Saved colorscheme setting"
endfunction

function! s:set(bg) abort
  let s:cs = getline(".")
  let s:bg = a:bg
  execute "colorscheme" s:cs
  let &bg = a:bg
  redraw!
endfunction

function! s:openbuf() abort
  let s:cs = get(g:, "colors_name", "default")
  let s:bg = &bg
  call vimrc#selector#openbuf(funcref("s:colors"))
  nnoremap <buffer> <nowait> d :<C-u>call <SID>set("dark")<CR>
  nnoremap <buffer> <nowait> l :<C-u>call <SID>set("light")<CR>
  nnoremap <buffer> <nowait> <silent> q :<C-u>call <SID>save()<CR>
endfunction

nnoremap <silent> cs :<C-u>call <SID>openbuf()<CR>

" }}}

" vim: set fdm=marker:
" }}}
" cat.vim: ~/.vim/scripts/config/command.vim {{{ 
" QuickRun用に雑バッファ作るやつ
function! s:scratch(filetype, usethis, mods) abort
  execute a:usethis == "!" ? "enew" : a:mods .. " new"
  setlocal buftype=nofile bufhidden=hide noswapfile
  let &filetype = a:filetype
endfunction

command! -bang -nargs=1 Scratch call s:scratch(<q-args>, "<bang>", "<mods>")

" うるさい黙れ
command! ShutUp autocmd! vimrc_sound

let s:jobs = {}
let s:plugdir = "~/.vim/pack/temp/start"
function! s:gitclone_end(ch) abort
  let j = ch_getjob(a:ch)
  packloadall
  helptags ALL
  echomsg s:jobs[j] .. " installed."
endfunction

function! s:echo(_, msg) abort
  echo a:msg
endfunction

function! s:gitclone_temp(url) abort
  let cmd = printf('mkdir -p %s ; cd %s ; git clone --depth=1 --progress %s |& stdbuf -i0 -o0 tr "\r" "\n"', s:plugdir, s:plugdir, a:url)
  let j = job_start(["bash", "-c", cmd], {
        \ "out_cb": funcref("s:echo"),
        \ "close_cb": funcref("s:gitclone_end"),
        \ })
  let s:jobs[j] = a:url
endfunction

command! -nargs=1 Templug call s:gitclone_temp(<f-args>)
" }}}
" cat.vim: ~/.vim/scripts/config/command/backupdiff.vim {{{ 
function! s:showfile(buf, file)
  call deletebufline(a:buf, 1, "$")
  call setbufline(a:buf, 1, readfile(a:file))
  diffupdate
endfunction

function! s:bdiff() abort
  let pname = substitute(resolve(expand("%:p")), "/", "%", "g")
  let path = substitute(printf("%s/%s*", &backupdir, pname), "/\\+", "/", "g")
  let files = sort(map(glob(path, v:true, v:true), "[v:val, getftime(v:val)]"), {a, b -> b[1] - a[1]})

  tab split
  diffthis
  let ft = &l:ft
  botright vertical new
  setlocal buftype=nofile bufhidden=hide noswapfile
  let &l:ft = ft
  diffthis
  let db = bufnr("%")

  botright new
  setlocal buftype=nofile bufhidden=hide noswapfile
  execute "resize" &cmdwinheight
  let w:diffbuf = db
  let w:files = files
  call setbufline("%", 1, map(copy(files), "strftime('%Y-%m-%dT%T', v:val[1])"))
  call s:showfile(db, files[0][0])
  autocmd CursorMoved <buffer> call s:showfile(w:diffbuf, w:files[line(".") - 1][0])
  nnoremap <buffer> h 1<C-w><C-w>
  nnoremap <buffer> l 2<C-w><C-w>
endfunction

command! BackupDiff call s:bdiff()
" }}}
" cat.vim: ~/.vim/scripts/config/edit.vim {{{ 
set modeline
set modelines=5

syntax enable
filetype plugin indent on

set tabstop=2
set autoindent
set expandtab
set shiftwidth=2

"コマンドライン補完等で大文字打つのが面倒なので無視
set ignorecase

set backspace=indent,eol,start
set autoread
set pumheight=5
set hidden
set virtualedit=block
set nrformats-=octal

" シェルの変数のファイル名補完をするときに不便なので
set isfname-==

" ウィンドウを後方に向けて開く
set splitbelow
set splitright
" }}}
" cat.vim: ~/.vim/scripts/config/files.vim {{{ 
if !v:vim_did_enter
  const s:dir = $HOME .. "/.vim/tmp//"
  const s:bdir = $HOME .. "/.vim/backup//"
  const s:udir = $HOME .. "/.vim/undo//"
endif

"swap
call mkdir(s:dir, "p")
let &directory = s:dir

"backup
call mkdir(s:bdir, "p")
set backup
set backupcopy=yes
let &backupdir = s:bdir
augroup vimrc
  " From help
  autocmd BufWritePre * let &bex = '-' .. strftime("%Y%b%d%X") .. '~'
augroup END

"viminfo
set viminfo+=n~/.vim/viminfo

"undo
call mkdir(s:udir, "p")
exec 'set undodir=' .. s:udir
set undofile

"!が必要なコマンドを実行した時に確認をとってくれる
set confirm

set fileencodings=utf-8,sjis,cp932,euc-jp
set fileformats=unix,dos,mac
" }}}
" cat.vim: ~/.vim/scripts/config/filetype/_.vim {{{ 
"一行のものとか
autocmd vimrc FileType make setlocal noexpandtab
" }}}
" cat.vim: ~/.vim/scripts/config/filetype/help.vim {{{ 
set helplang=ja
"helpのタグ移動を楽にするやつ
augroup vimrc
  autocmd FileType help nnoremap <buffer> <CR> <C-]>
  autocmd FileType help nnoremap <buffer> <BS> <C-T>
augroup END
" }}}
" cat.vim: ~/.vim/scripts/config/filetype/lisp.vim {{{ 
autocmd vimrc FileType clojure,lisp,scheme call vimrc#filetype#lispmap()
" }}}
" cat.vim: ~/.vim/scripts/config/filetype/vim.vim {{{ 
" 行継続のアレ
let g:vim_indent_cont = 0

function s:ft_init()
  "zc+任意のキーで<C-?>を入力
  inoremap <buffer> <expr> zc printf("<C-%s>", nr2char(getchar()))

  "一部分の設定はsonictemplateの方に移動してある
  inoremap <buffer> <expr> z# vimrc#autoloadname()
  inoremap <buffer> z<CR> <lt>CR>
  inoremap <buffer> z<Space> <lt>Space>
  inoremap <buffer> zS <lt>SID>
  inoremap <buffer> zb <lt>buffer>
  inoremap <buffer> zl <lt>lt>
  inoremap <buffer> zp <lt>Plug>
  inoremap <buffer> zs <lt>silent>
  inoremap <buffer> zt <lt>Tab>
endfunction

autocmd vimrc FileType vim call s:ft_init()
" }}}
" cat.vim: ~/.vim/scripts/config/mapping/edit.vim {{{ 
"Yの挙動を他の物に寄せる
nnoremap Y y$

nnoremap Q @@

" Reselect visual block after adjusting indentation
xnoremap < <gv
xnoremap > >gv

" Useful substitute pattern from https://github.com/tlhunter/vimrc
nnoremap S :<C-u>%s/\v/g<Left><Left>
vnoremap S :s/\v/g<Left><Left>

inoremap <C-l> <del>

" End insertmode on 'jk'
inoremap jk <Esc>

" ISO8601スタイルで日付挿入
cnoremap <C-r><C-d> _<C-r>=strftime("%Y%m%dT%H%M%S")<CR>
inoremap <C-r><C-d> _<C-r>=strftime("%Y%m%dT%H%M%S")<CR>
" }}}
" cat.vim: ~/.vim/scripts/config/mapping/motion.vim {{{ 
"shortcut to page <up|down>
noremap <Space>j <C-f>
noremap <Space>k <C-b>

" Ctrlキーは人間にやさしくない
nnoremap <Space>w <C-w>

" Tab movement by <Tab>
nnoremap <Tab> :<C-u>tabnext<CR>

nnoremap j gj
nnoremap k gk

" Scroll to cursor line at center of window when searching
nnoremap n nzz
nnoremap N Nzz

" Pseudo page down by mouse click
nnoremap <RightMouse> z<CR>

" 楽にタグ移動がしたいっ
nnoremap <expr> <CR> empty(getcmdwintype()) && &buftype != "quickfix" ? "<C-]>" : "<CR>"

" マーク時に既にマークされてるものをいい感じに表示してくれるやつ {{{
function! s:marks(key)
  redraw!
  try
    marks abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
    echo ""
  catch
  endtry
  call feedkeys(a:key .. nr2char(getchar()), "n")
endfunction

" mark and
noremap m :<C-u>call <SID>marks("m")<CR>
" jump
noremap ` :<C-u>call <SID>marks("`")<CR>
noremap <Space>m :<C-u>call <SID>marks("`")<CR>

" }}}

" Tab movements {{{

nnoremap <S-Tab> :<C-u>tabprevious<CR>
nnoremap <Tab> :<C-u>tabnext<CR>
nnoremap <Space>th :<C-u>tabprevious<CR>
nnoremap <Space>tl :<C-u>tabnext<CR>
nnoremap <Space>tn :<C-u>tabnew<CR>
nnoremap <Space>tc :<C-u>tabclose<CR>
nnoremap <Space>tC :<C-u>tabclose!<CR>
nnoremap <C-f> :<C-u>tabnext<CR>
nnoremap <C-b> :<C-u>tabprevious<CR>

" }}}

" from https://github.com/tyru/config/blob/c765a18ee9577cd8f62e654e348ad066d4e4d3e2/home/volt/rc/default/vimrc.vim#L489-L506
function! s:same_indent(dir) abort
  let lnum = line('.')
  let width = col('.') <= 1 ? 0 : strdisplaywidth(matchstr(getline(lnum)[: col('.')-2], '^\s*'))
  while 1 <= lnum && lnum <= line('$')
    let lnum += (a:dir ==# '+' ? 1 : -1)
    let line = getline(lnum)
    if width >= strdisplaywidth(matchstr(line, '^\s*')) && line =~# '^\s*\S'
      break
    endif
  endwhile
  return abs(line('.') - lnum) . a:dir
endfunction
nnoremap <expr><silent> sj <SID>same_indent('+')
nnoremap <expr><silent> sk <SID>same_indent('-')
onoremap <expr><silent> sj <SID>same_indent('+')
onoremap <expr><silent> sk <SID>same_indent('-')
xnoremap <expr><silent> sj <SID>same_indent('+')
xnoremap <expr><silent> sk <SID>same_indent('-')

" vim: fdm=marker
" }}}
" cat.vim: ~/.vim/scripts/config/mapping/op.vim {{{ 
"常にコマンドウィンドウ使いたい
nnoremap : q:i

" incsearchを消す
nnoremap <Space>h :<C-u>nohlsearch<CR>

nnoremap <Space>s :<C-u>update<CR>
nnoremap <Space>q :<C-u>confirm qa<CR>
nnoremap qq :<C-u>confirm qa<CR>
xnoremap qq :<C-u>confirm qa<CR>

"vimrcへのショートカット

function! s:open_vimrc_callback(id, result)
  if a:result == 1
    e ~/.vim/vimrc
    lcd %:p:h
  elseif a:result == 2
    e ~/.vim/gvimrc
    lcd %:p:h
  elseif a:result == 3
    Fern ~/.vim -drawer -reveal=~/.vim/scripts/config
  elseif a:result == 4
    Fern ~/.vim -drawer -reveal=~/.vim/scripts/plug
  endif
endfunction

function! s:open_vimrc()
  if has("popupwin")
    call popup_menu(['vimrc', 'gvimrc', 'config(using fern)', 'plugins(using fern)'], #{
          \ callback: funcref("s:open_vimrc_callback"),
          \ filter: 'popup_filter_menu',
          \ })
  else
    edit $MYVIMRC
    lcd %:p:h
  endif
endfunction

nnoremap <Space>. :<C-u>edit $MYVIMRC<CR>:lcd %:p:h<CR>
nnoremap <silent> <Space>. :<C-u>call <SID>open_vimrc()<CR>
nnoremap <Space><Space>. :<C-u>source $MYVIMRC<CR>

nnoremap <Space>CD :<C-u>cd %:p:h<CR>
nnoremap <Space>cd :<C-u>lcd %:p:h<CR>

"helpを大画面で
nnoremap H :<C-u><Bar><Space>silent! only<Home>h<Space>
" }}}
" cat.vim: ~/.vim/scripts/config/mapping/terminal.vim {{{ 
"escape from terminal when pressed 'fj'
tnoremap fj <C-\><C-n>

" Terminal boot
nnoremap <Space>te :<C-u>terminal ++curwin<CR>

" タブ移動するのに一々モード抜けるのしんどいので
tnoremap <C-f> <C-w>:<C-u>tabnext<CR>
tnoremap <C-b> <C-w>:<C-u>tabprevious<CR>
" }}}
" cat.vim: ~/.vim/scripts/config/ripgrep.vim {{{ 
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
" }}}
" cat.vim: ~/.vim/scripts/config/screen.vim {{{ 
set ruler
set showcmd
set showmatch
set matchtime=1

"インクリメンタルサーチは便利
set incsearch
set hlsearch

set laststatus=2

"移動に便利なので相対行番号表示
set number
set relativenumber
"8.2のどこかで'cursorline'設定しないとCursorLineNrが適用されなくなった？
"Neovimにはない
if !has("nvim")
  set cursorline
  set cursorlineopt=number
endif

"ターミナルによっては設定に失敗するので強制的に設定
set ambiwidth=double

"たまにマウス使うので
set mouse=a

set diffopt=internal,filler,algorithm:histogram

" gvimみたいにカーソルを変化させる
" neovimだとこの設定自体がない
if !has("nvim")
  let &t_ti .= "\e[1 q"
  let &t_SI .= "\e[5 q"
  let &t_EI .= "\e[1 q"
  let &t_te .= "\e[0 q"
endif
" }}}
" cat.vim: ~/.vim/scripts/config/tmp/colors.vim {{{ 
let g:colors_name = 'bluenote256'
set background=light
" }}}
" cat.vim: ~/.vim/scripts/config/tmp/guifont.vim {{{ 
if has('gui_running')
let &guifont = 'JFドットk12x10 7.5'
endif
" }}}
if has("nvim")
" cat.vim: ~/.vim/scripts/config.nvim/files.vim {{{ 
set directory=~/.vim/nvim/tmp//
set viminfo& viminfo+=n~/.vim/nvim/info
" }}}
" cat.vim: ~/.vim/scripts/config.nvim/help.vim {{{ 
"vimdoc-jaを使わない
set helplang=en
" }}}
else
endif

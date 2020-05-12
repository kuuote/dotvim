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

" (と)を押しづらい^と$に割り振り(両キーは変換無変換に割り振ってるため便利可能)
" 元マップの文は多分全く使わんのでおk
nnoremap <expr> ( indent(".") + 1 < col(".") ? "^" : "0"
nnoremap ) $

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
nnoremap <Space>tq :<C-u>tabclose<CR>
nnoremap <Space>tQ :<C-u>tabclose!<CR>
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

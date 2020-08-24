let s:bufnr = -1
" 開く前にいた所
let s:winid = -1
let s:matchstr = ""

" 雑ファジーファインド
function! s:match(str, pat) abort
  let found = []
  let pos = len(a:str) - 1
  for c in a:pat
    while pos > -1
      if a:str[pos] ==? c
        call insert(found, pos + 1)
        let pos -= 1
        break
      endif
      let pos -= 1
    endwhile
  endfor
  return found
endfunction

function! s:hl(l, m) abort
  if has("textprop")
    for p in a:m
      call prop_add(a:l, p, {"type": "fzmatch"})
    endfor
  else
    for p in a:m
      call matchaddpos("FzMatch", [[a:l, p]])
    endfor
  endif
endfunction

function! vimrc#selector#matchclear() abort
  let s:matchstr = ""
endfunction

" Viewの更新、forceが真ならソースの計算し直し
" TODO:
" ソースの要素が文字列であればdisplay=actual
" 配列([display<string>, actual<object>])であればdisplay!=actual
" ソースのキャッシュは[display, match, actual]の順に格納する
function! vimrc#selector#refresh(force) abort
  if a:force || s:cache is v:null
    if type(s:source) == v:t_func
      let s:cache = s:source()
    else
      let s:cache = s:source
    endif
  endif
  %d_
  call clearmatches()
  let fz = reverse(split(s:matchstr, '\zs'))
  let g:hoge = []
  for l in s:cache
    let m = s:match(l, fz)
    if len(m) == len(fz)
      call append(line("$"), l)
      call s:hl(line("$"), m)
    endif
  endfor
  1d_
endfunction

" 後始末をしてからcallback呼び出し
" 引数が渡っていたらそれをcallbackに渡す
" 無かったら現在行を渡す
function! vimrc#selector#finish(callback, ...) abort
  let result = getline(".")
  call vimrc#selector#close()
  if a:0 == 0
    call a:callback(result)
  else
    call call(a:callback, a:000)
  endif
endfunction

" タブを閉じてお掃除
function! vimrc#selector#close() abort
  augroup vimrc_fz
    autocmd!
  augroup END
  execute "silent! bdelete" s:bufnr
  call win_gotoid(s:winid)
  let s:winid = -1
  " deref
  let s:source = v:null
  let s:sink = v:null
  let s:cache = v:null
  let s:matchstr = ""
  silent doautocmd User FzClose
endfunction

function! s:inithl() abort
  hi default FzMatch term=underline cterm=underline gui=underline
  if has("textprop")
    silent! call prop_type_add("fzmatch", {"highlight": "FzMatch"})
  endif
endfunction

function! s:input_cb() abort
  let s:matchstr = getcmdline()
  call vimrc#selector#refresh(v:false)
  redraw
endfunction

function! s:input() abort
  augroup vimrc_fz#input
    autocmd CmdlineChanged * call s:input_cb()
    autocmd CmdlineLeave * autocmd! vimrc_fz#input
  augroup END
  call vimrc#selector#matchclear()
  call vimrc#selector#refresh(v:false)
  cnoremap <buffer> <Space> <CR>
  call input("candy:")
endfunction

" タブを開く、オプションは下記の要素を渡す
" source: 選択のソース
function! vimrc#selector#openbuf(source, ...) abort
  " 既に開かれていたら先に閉じる
  call vimrc#selector#close()
  let s:winid = win_getid()
  tabnew
  setlocal buftype=nofile bufhidden=hide noswapfile
  call s:inithl()
  autocmd vimrc_fz ColorScheme * call s:inithl()
  let s:bufnr = bufnr("%")
  let s:source = a:source
  autocmd vimrc_fz WinEnter * if bufnr("%") != s:bufnr && empty(getcmdwintype()) | execute "call vimrc#selector#close()" | endif
  nnoremap <buffer> <nowait> <silent> i :<C-u>call <SID>input()<CR>
  call vimrc#selector#refresh(v:true)
endfunction

" Vim 9は対応してないと構文で死ぬので
finish
if !exists(":def")
  finish
endif
def! s:match(str: string, pat: list<string>): list<number>
  let found: list<number> = []
  let pos = len(str) - 1
  for c in pat
    while pos > -1
      if strpart(str, pos, 1) ==? c
        insert(found, pos + 1)
        pos = pos - 1
        break
      endif
      pos = pos - 1
    endwhile
  endfor
  return found
enddef

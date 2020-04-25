" 頑張らないMRU/W

let s:mru = []
let s:mrw = []

let g:mru_file = get(g:, "mru_file", "")
let g:mrw_file = get(g:, "mrw_file", $HOME .. "/.mrw")

function! s:init() abort
  let s:mru = filter(copy(v:oldfiles), "filereadable(v:val)")
  let s:mru = map(s:mru, "resolve(fnamemodify(v:val, ':p'))")
endfunction

function! s:read(type) abort
  let f = g:{a:type}_file
  if !empty(f)
    try
      let s:[a:type] = readfile(f)
    catch
    endtry
  endif
  return s:[a:type]
endfunction

function! s:write(type) abort
  let f = g:{a:type}_file
  if !empty(f)
    call writefile(s:[a:type], f)
  endif
endfunction

function! s:add(type) abort
  if !empty(&buftype) || empty(bufname("%"))
    return
  endif
  call s:read(a:type)
  let path = resolve(expand("%:p"))
  let v = s:read(a:type)
  let v = filter(v, "v:val != path")
  let v = insert(v, path)
  let s:[a:type] = v
  call s:write(a:type)
endfunction

" ファイルが無いこともあるので匿名バッファを作る
" 編集はできないが仕方ない
function! s:open(type) abort
  enew
  setlocal buftype=nofile bufhidden=hide noswapfile
  let v = s:read(a:type)
  call setline(1, v)
  nnoremap <buffer> <CR> gf
endfunction

augroup vimrc_mru
  autocmd!
  autocmd VimEnter * call s:init()
  autocmd BufEnter,BufWritePost * call s:add("mru")
  autocmd BufWritePost * call s:add("mrw")
augroup END

nnoremap <silent> mru :<C-u>call <SID>open("mru")<CR>
nnoremap <silent> mrw :<C-u>call <SID>open("mrw")<CR>

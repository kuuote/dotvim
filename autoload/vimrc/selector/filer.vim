let s:pwd = "/"
let s:dothide = 1

function! s:togglehide() abort
  let s:dothide = !s:dothide
  call vimrc#selector#refresh(v:true)
  echo printf("%s dotfiles", s:dothide ? "hide" : "show")
endfunction

function! s:readdir(dir) abort
  execute "lcd" s:pwd
  let dir = glob("*", v:true, v:true)
  let dir = extend(dir, glob(".*", v:true, v:true))
  if s:dothide
    return filter(dir, {_, d -> d !~ '\v^\.'})
  else
    return filter(dir, {_, d -> d !~ '\v^\.%(\.)?$'})
  endif
endfunction

function! s:comp(a, b) abort
  let a = a:a[-1:] == "/" ? -1 : 1
  let b = a:b[-1:] == "/" ? -1 : 1
  let c = a - b
  return c != 0 ? c :
  \      a:a < a:b ? -1 :
  \      a:a == a:b ? 0 : 1
endfunction

function! s:source() abort
  let entry = map(s:readdir(s:pwd), "v:val .. (isdirectory(s:pwd .. '/' .. v:val) ? '/' : '')")
  return sort(entry, "s:comp")
endfunction

function! s:redraw() abort
  let &tabline = s:pwd
endfunction

function! s:refresh() abort
  call vimrc#selector#matchclear()
  call vimrc#selector#refresh(v:true)
  call s:redraw()
endfunction

function! s:simplify(path) abort
  let p = substitute(a:path, "/\\+", "/", "g")
  let p = substitute(p, "/\\+$", "", "")
  return simplify(p)
endfunction

function! s:open_cb(name) abort
  execute "buf" bufnr(simplify(s:pwd .. '/' .. a:name), v:true)
endfunction

function! s:open(name) abort
  let n = s:simplify(a:name)
  call vimrc#selector#finish(funcref("s:open_cb"), n)
endfunction

function! s:chdir(dir) abort
  let s:pwd = s:simplify(a:dir)
  call s:refresh()
endfunction

function! s:up() abort
  call s:chdir(fnamemodify(s:pwd, ":h"))
endfunction

function! s:down() abort
  let name = getline(".")
  if name[-1:] == '/'
    call s:chdir(s:pwd .. "/" .. name)
  else
    call s:open(name)
  endif
endfunction

function! s:onclose() abort
  let &tabline = s:save_tabline
  autocmd! FzFiler
endfunction

function! vimrc#selector#filer#openbuf(path) abort
  let s:pwd = empty(a:path) ? expand("%:p:h") : fnamemodify(a:path, ":p")
  if !isdirectory(s:pwd)
    let s:pwd = getcwd()
  endif
  let s:pwd = s:simplify(s:pwd)
  call vimrc#selector#openbuf(funcref("s:source"))
  setfiletype fzfiler
  syn match Directory ".*/"
  nnoremap <buffer> <nowait> <silent> d :<C-u>call <SID>togglehide()<CR>
  nnoremap <buffer> <nowait> <silent> h :<C-u>call <SID>up()<CR>
  nnoremap <buffer> <nowait> <silent> l :<C-u>call <SID>down()<CR>
  nnoremap <buffer> <nowait> <silent> N :<C-u>call <SID>open(input("name:"))<CR>
  nnoremap <buffer> <nowait> <silent> <CR> :<C-u>call <SID>down()<CR>
  augroup FzFiler
    autocmd User FzClose call s:onclose()
  augroup END
  let s:save_tabline = &tabline
  call s:redraw()
endfunction

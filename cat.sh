#!/bin/sh
":" << finish
" vim: set ft=vim:

function! s:print(obj) abort
  let obj = a:obj
  if type(obj) != v:t_string
    let obj = string(obj)
  endif
  call setline(1, obj)
  1print
endfunction

let s:vimrc = readfile(expand("vimrc"))
call s:print("read")
let s:cat = [] " ねこです


function! s:addscripts(glob) abort
  call s:print("process " .. a:glob)
  let home = expand("~")
  let exp = sort(glob(a:glob, v:true, v:true))
  for p in exp
    call add(s:cat, printf("\" cat.vim: %s {{{ ", substitute(p, home, "~", "")))
    call extend(s:cat, readfile(p))
    call add(s:cat, "\" }}}")
    call s:print("concat " .. p)
  endfor
endfunction

for l in s:vimrc
  if l !~ "vimrc#loadscripts"
    call add(s:cat, l)
    continue
  endif
  call s:addscripts(l[stridx(l, '"') + 1 : strridx(l, '"') - 1])
endfor

call writefile(s:cat, "vimrc_cat.vim")
call s:print("write")

qa!
finish

vim --clean -n -e -s -S $0

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

try
  {{_cursor_}}
catch
  call s:print([v:exception, v:throwpoint])
  cquit
finally
  qa!
endtry
finish

vim --clean -n -e -s -S $0

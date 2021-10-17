let s:source = expand('<sfile>:h') .. '/vimsel.c'
let s:exe = '/tmp/vimsel'
let s:haystack = '/tmp/vimsel.lst'
let s:filtered = '/tmp/vimsel.out'

function! selector#filter#exact_c#filter(needle) abort
  call system('/tmp/vimsel ' .. a:needle)
  if v:shell_error
    return []
  else
    return readfile('/tmp/vimsel.out')
  endif
endfunction

function! selector#filter#exact_c#gather(haystack) abort
  call writefile(a:haystack, '/tmp/vimsel.lst')
  if getfperm(s:exe)[2] !=# 'x' || getftime(s:source) > getftime(s:exe)
    echom system(printf('gcc -o %s %s', s:exe, s:source))
  endif
endfunction

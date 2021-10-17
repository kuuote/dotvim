let s:source = expand('<sfile>:h') .. '/vimsel.c'
let s:exe = '/tmp/vimsel'
let s:haystack = '/tmp/vimsel.lst'
let s:filtered = '/tmp/vimsel.out'

function! selector#filter#fzf#filter(needle) abort
  let cmd = printf('cat %s | fzf -f %s > %s', s:haystack, string(a:needle), s:filtered)
  call system(cmd)
  if v:shell_error
    return []
  else
    return readfile(s:filtered)
  endif
endfunction

function! selector#filter#fzf#gather(haystack) abort
  call writefile(a:haystack, s:haystack)
endfunction

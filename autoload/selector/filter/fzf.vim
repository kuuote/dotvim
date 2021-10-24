let s:source = expand('<sfile>:h') .. '/vimsel.c'
let s:haystack = tempname()
let s:filtered = tempname()

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

let s:source = expand('<sfile>:h') .. '/vimsel.c'
let s:exe = '/tmp/vimsel'
let s:haystack = '/tmp/vimsel.lst'
let s:filtered = '/tmp/vimsel.out'

function! selector#filter#grep#filter(needle) abort
  let args = split(a:needle)
  if empty(args)
    return readfile(s:haystack)
  endif
  let matcher = join(map(args, 'printf("-e %s", string(v:val))'), ' ')
  let cmd = printf('grep -iF %s %s > %s', matcher, s:haystack, s:filtered)
  call system(cmd)
  if v:shell_error
    return []
  else
    return readfile(s:filtered)
  endif
endfunction

function! selector#filter#grep#gather(haystack) abort
  call writefile(a:haystack, s:haystack)
endfunction

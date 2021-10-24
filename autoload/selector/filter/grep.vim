let s:source = expand('<sfile>:h') .. '/vimsel.c'
let s:haystack = tempname()
let s:filtered = tempname()

function! selector#filter#grep#filter(needle) abort
  let args = split(a:needle)
  if empty(args)
    return readfile(s:haystack)
  endif
  let matcher = join(map(args, 'printf("grep -iF %s", string(v:val))'), '|')
  let cmd = printf('cat %s | %s > %s', s:haystack, matcher, s:filtered)
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

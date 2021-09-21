function! s:filter(str, expr) abort
  let s = tolower(a:str)
  return eval(a:expr)
endfunction

function! selector#filter#exact#filter(haystack, needle) abort
  let e = join(map(split(tolower(a:needle)), 'printf("stridx(s, %s) != -1", string(v:val))'), ' && ')
  if empty(e)
    let e = '1'
  endif
  return filter(copy(a:haystack), 's:filter(v:val, e)')
endfunction

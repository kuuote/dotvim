function! selector#filter#denops#filter(haystack, needle) abort
  if !get(g:, 'vimrc#init_denops', v:false)
    return a:haystack
  endif
  return denops#request('vimrc', 'select' , [a:haystack, a:needle])
endfunction

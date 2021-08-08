function! selector#filter#denops#filter(haystack, needle) abort
  return denops#request('vimrc', 'select' , [a:haystack, a:needle])
endfunction

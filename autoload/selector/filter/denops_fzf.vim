function! selector#filter#denops_fzf#filter(haystack, needle) abort
  return denops#request('vimrc', 'fzf' , [a:haystack, a:needle])
endfunction

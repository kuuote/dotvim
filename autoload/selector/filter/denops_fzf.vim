function! selector#filter#denops_fzf#filter(haystack, needle) abort
  if !get(g:, 'vimrc#init_denops', v:false)
    return a:haystack
  endif
  return denops#request('vimrc', 'fzf' , [a:haystack, a:needle])
endfunction

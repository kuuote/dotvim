function! selector#filter#denops_fzf#filter(haystack, needle) abort
  call denops#plugin#wait('vimrc')
  return denops#request('vimrc', 'fzf' , [a:haystack, a:needle])
endfunction

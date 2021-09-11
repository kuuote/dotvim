function! selector#filter#denops#filter(haystack, needle) abort
  call denops#plugin#wait('vimrc')
  return denops#request('vimrc', 'select' , [a:haystack, a:needle])
endfunction

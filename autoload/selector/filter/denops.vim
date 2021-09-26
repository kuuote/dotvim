function! selector#filter#denops#filter(haystack, needle) abort
  return denops#request('vimrc_select', 'exact' , [a:needle])
endfunction

function! selector#filter#denops#gather(haystack) abort
  call denops#plugin#wait('vimrc_select')
  call denops#request('vimrc_select', 'gather', [a:haystack])
endfunction

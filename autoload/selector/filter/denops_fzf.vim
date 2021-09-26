function! selector#filter#denops_fzf#filter(needle) abort
  return denops#request('vimrc_select', 'fzf' , [a:needle])
endfunction

function! selector#filter#denops_fzf#gather(haystack) abort
  call denops#plugin#wait('vimrc_select')
  call denops#request('vimrc_select', 'gather', [a:haystack])
endfunction

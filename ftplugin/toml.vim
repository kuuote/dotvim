function! s:select_block() abort
  let view = winsaveview()
  keeppatterns ?'''\zs
  execute "normal! j\<Home>o"
  keeppatterns /'''
  execute "normal! k\<End>ozz"
endfunction

" inner hook
" parteditするためにhook部分を選択する
xnoremap <buffer> ih <Cmd>call <SID>select_block()<CR>

command! -buffer Sortoml call denops#request('vimrc', 'blockSort', [1, line('$'), '..plugins]]', 'repo.*'])

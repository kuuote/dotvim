function! vimrc#filetype#lispmap() abort
  " 後続の括弧を次行に追いやる
  inoremap <buffer> z<CR> <CR><Up><End>
endfunction

call minpac#add('mattn/vim-goimports', {'type': 'opt'})

function! s:load_go() abort
  packadd vim-goimports
  doautocmd FileType go
endfunction

autocmd FileType go ++once call s:load_go()

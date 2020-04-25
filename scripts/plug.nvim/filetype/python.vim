call minpac#add('numirias/semshi', {'type': 'opt'})

function! s:load_python_nvim() abort
  packadd semshi
  silent! UpdateRemotePlugins
  doautocmd FileType python
endfunction

if has("nvim")
  autocmd FileType python ++once call s:load_python_nvim()
endif

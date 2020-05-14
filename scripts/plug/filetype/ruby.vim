call minpac#add('pocke/iro.vim', {'type': 'opt'})

function! s:load_ruby() abort
  if has("ruby")
    packadd iro.vim
    doautocmd FileType ruby
  endif
endfunction

autocmd FileType ruby ++once call s:load_ruby()

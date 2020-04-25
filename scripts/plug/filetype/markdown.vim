call minpac#add('previm/previm', {'type': 'opt'})

let g:previm_open_cmd = "firefox"

function! s:load_previm() abort
  packadd previm
  execute "doautocmd FileType" expand("<amatch>")
  PrevimWipeCache
endfunction

autocmd FileType *{mkd,markdown,rst,textile,asciidoc}* ++once call <SID>load_previm()

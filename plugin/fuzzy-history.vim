function! s:filter() abort
  let text = getcmdline()
  let newhist = copy(s:hist)
  let re = "\\v\\c" .. join(split(text, "\\zs"), ".*")
  call filter(newhist, {_, val -> val =~ re})
  call deletebufline("%", 1, "$")
  call setline(1, newhist)
  call cursor("$", 1)
  redraw
endfunction

function! s:cmdline() abort
  autocmd FuzzyHistory CmdlineChanged * call s:filter()
  call input("candy:")
endfunction

function! s:leave() abort
  autocmd! FuzzyHistory CmdlineChanged
endfunction

augroup FuzzyHistory
  autocmd!
  autocmd CmdwinEnter * let s:hist = getline(1, "$")
  autocmd CmdlineLeave * autocmd! FuzzyHistory CmdlineChanged
augroup END

" nnoremap <silent> <buffer> <C-f> :<C-u>call <SID>cmdline()<CR>
nnoremap <silent> <expr> <C-f> (empty(getcmdwintype()) ? "q:" : "") .. ":<C-u>call <SID>cmdline()<CR>"

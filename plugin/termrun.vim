let s:termbuf = -1

function! s:setup(args) abort
  let s:winid = win_getid()
  let s:args = a:args
  nnoremap <silent> ' :<C-u>call <SID>open()<CR>
endfunction

function! s:open() abort
  only
  silent! execute "bdelete!" s:termbuf
  execute "terminal" s:args
  let s:termbuf = winbufnr(0)
  setlocal nonumber norelativenumber
  call win_gotoid(s:winid)
endfunction

command! -nargs=* TermRunSetup call s:setup(<q-args>)

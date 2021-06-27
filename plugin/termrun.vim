let g:termrun_modifier = get(g:, "termrun_modifier", "")
let s:termbuf = -1

function! s:setup(args) abort
  let s:args = a:args
  nnoremap <silent> <CR>r :<C-u>call <SID>open()<CR>
endfunction

function! s:open() abort
  let view = winsaveview()
  update
  silent! only
  let s:winid = win_getid()
  silent! execute "bdelete!" s:termbuf
  execute g:termrun_modifier "terminal" s:args
  let s:termbuf = winbufnr(0)
  setlocal nonumber norelativenumber
  call win_gotoid(s:winid)
  call winrestview(view)
endfunction

command! -nargs=* TermRunSetup call s:setup(<q-args>)

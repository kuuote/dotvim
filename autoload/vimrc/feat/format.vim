function! vimrc#feat#format#execute(cmd) abort
  let result = systemlist(a:cmd, getline(1, '$'))
  if v:shell_error != 0
    for l in result
      echoerr l
    endfor
    return
  endif
  let view = winsaveview()
  call deletebufline('%', 1, '$')
  call setline(1, result)
  call winrestview(view)
endfunction

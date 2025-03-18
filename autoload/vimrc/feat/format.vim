function! vimrc#feat#format#execute(cmd) abort
  let shell = &shell
  setglobal shell=sh
  let view = winsaveview()
  try
    let result = systemlist(a:cmd, getline(1, '$'))
    if v:shell_error != 0
      for l in result
        echoerr l
      endfor
      return
    endif
    call deletebufline('%', 1, '$')
    call setline(1, result)
  finally
    call winrestview(view)
    let &shell = shell
  endtry
endfunction

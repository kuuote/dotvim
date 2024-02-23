function vimrc#feat#terminal#open(cmd = $SHELL, cwd = expand('%:p:h')) abort
  tabnew
  let winid = win_getid()
  if has('nvim')
    call termopen(a:cmd, {'cwd': a:cwd})
    execute printf('autocmd vimrc TermClose <buffer> call win_gotoid(%d)', winid)
  else
    call term_start(a:cmd, {'curwin': v:true, 'cwd': a:cwd, 'exit_cb': {->win_gotoid(winid)}})
  endif
endfunction


function vimrc#feat#terminal#open(cmd = $SHELL, cwd = expand('%:p:h')) abort
  tabnew
  if has('nvim')
    call termopen(a:cmd, {'cwd': a:cwd})
  else
    call term_start(a:cmd, {'curwin': v:true, 'cwd': a:cwd})
  endif
endfunction


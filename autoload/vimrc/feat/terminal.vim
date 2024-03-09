function s:on_close(args)
  call win_gotoid(a:args.from_winid)
  call vimrc#feat#tmux#focus()
endfunction

function vimrc#feat#terminal#open(cmd = $SHELL, cwd = expand('%:p:h')) abort
  tabnew
  execute 'tcd' a:cwd
  let args = {
  \   'from_winid': win_getid(),
  \ }
  if has('nvim')
    call termopen(a:cmd, {'cwd': a:cwd, 'on_exit': {->s:on_close(args)}})
    normal! G0
  else
    call term_start(a:cmd, {'curwin': v:true, 'cwd': a:cwd, 'exit_cb': {->s:on_close(args)}})
  endif
endfunction


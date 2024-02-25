if empty($TMUX_PANE)
  function vimrc#feat#tmux#focus()
  endfunction
else
  if has('nvim')
    function vimrc#feat#tmux#focus()
      call jobstart(printf('tmux select-window -t %s', $TMUX_PANE))
    endfunction
  else
    function vimrc#feat#tmux#focus()
      call job_start(printf('tmux select-window -t %s', $TMUX_PANE))
    endfunction
  endif
endif

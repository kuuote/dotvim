let s:job = -1

function s:wait() abort
  if has('nvim') && jobwait([s:job], 0)[0] == -1
    echo 'waiting unfinished make state'
    redraw
    call jobwait([s:job])
  endif
endfunction

function s:make_state_exit(...)
  echo 'make state exit'
endfunction

function vimrc#dpp#makestate_job()
  eval glob(g:vimrc#dpp_base .. '/*/cache.vim', 1, 1)->map('delete(v:val, "rf")')
  eval glob(g:vimrc#dpp_base .. '/*/state.vim', 1, 1)->map('delete(v:val, "rf")')
  if has('nvim')
    call jobstop(s:job)
    let s:job = jobstart(['nvim', '--headless', '-u', expand('$VIMDIR/vimrc')], {'on_exit': function('s:make_state_exit')})
  endif
endfunction

autocmd VimLeavePre * call s:wait()

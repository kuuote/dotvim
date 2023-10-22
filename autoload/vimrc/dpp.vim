let s:job = -1

let s:vimrc = findfile('vimrc', expand('<sfile>:p') .. ';')->fnamemodify(':p')
let s:base = get(g:, 'vimrc#dpp_base', '/tmp/dpp')

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
  eval glob(s:base .. '/*/cache.vim', 1, 1)->map('delete(v:val, "rf")')
  eval glob(s:base .. '/*/state.vim', 1, 1)->map('delete(v:val, "rf")')
  if has('nvim')
    call jobstop(s:job)
    let s:job = jobstart(['nvim', '--headless', '-u', s:vimrc], {'on_exit': function('s:make_state_exit')})
  endif
endfunction

autocmd VimLeavePre * call s:wait()

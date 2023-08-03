function! s:onexit_podtags(...) abort
  let g:hoge = 42
  echomsg 'podtags completed'
endfunction

function! s:run_podtags() abort
  let cmd = ['sh', '-c', 'scripts/podtags.sh']
  if has('nvim')
    call jobstart(cmd, {'stdin': 'null', 'cwd': $DOTVIM, 'on_exit': function('s:onexit_podtags')})
  else
    call job_start(cmd, {'in_io': 'null', 'cwd': $DOTVIM, 'exit_cb': function('s:onexit_podtags')})
  endif
endfunction

augroup vimrc.run_podtags
  autocmd! * <buffer>
  autocmd BufWritePost <buffer> call s:run_podtags()
augroup END

setlocal iskeyword+=-

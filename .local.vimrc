function! s:onexit_podtags(...) abort
  echomsg 'podtags completed'
endfunction

let s:root = expand('<sfile>:p:h')

function! s:run_podtags() abort
  let cmd = ['sh', '-c', 'scripts/podtags.sh']
  if has('nvim')
    call jobstart(cmd, {'stdin': 'null', 'cwd': s:root, 'on_exit': function('s:onexit_podtags')})
  else
    call job_start(cmd, {'in_io': 'null', 'cwd': s:root, 'exit_cb': function('s:onexit_podtags')})
  endif
endfunction

augroup vimrc.run_podtags
  autocmd! * <buffer>
  autocmd BufWritePost <buffer> call s:run_podtags()
augroup END

setlocal iskeyword+=-

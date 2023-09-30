let s:cd = expand('<sfile>:p:h')

let g:vimrc_make_state_job = -1
function s:make_state() abort
  " call system('rm -rf /tmp/dpp/cache*')
  " call system('rm -rf /tmp/dpp/state*')
  if has('nvim')
    call jobstop(g:vimrc_make_state_job)
    let g:vimrc_make_state_job = jobstart(['nvim', '--headless', '-u', s:cd .. '/makestate.vim'], {'stdin': 'null'})
  endif
endfunction

"    call jobstart(cmd, {'stdin': 'null', 'cwd': s:root, 'on_exit': function('s:onexit_podtags')})

augroup new_vimrc
  autocmd! * <buffer>
  autocmd BufWritePost <buffer> call s:make_state()
  autocmd BufWritePost <buffer> call delete('/tmp/inline.vim', 'rf')
augroup END

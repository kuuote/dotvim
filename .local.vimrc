let s:cd = expand('<sfile>:p:h')

function s:make_state_exit(...)
  echo 'make state exit'
endfunction

let g:vimrc_make_state_job = -1
function s:make_state() abort
  " if exists('#dpp')
  "   call dpp#make_state('/tmp/dpp', s:cd .. '/conf/dpp.ts')
  "   return
  " endif
  eval glob(g:vimrc#dpp_base .. '/*/cache.vim', 1, 1)->map('delete(v:val, "rf")')
  eval glob(g:vimrc#dpp_base .. '/*/state.vim', 1, 1)->map('delete(v:val, "rf")')
  if has('nvim')
    call jobstop(g:vimrc_make_state_job)
    let g:vimrc_make_state_job = jobstart(['nvim', '--headless', '-u', s:cd .. '/vimrc'], {'on_exit': function('s:make_state_exit')})
  endif
endfunction

augroup new_vimrc
  autocmd! * <buffer>
  autocmd BufWritePost <buffer> call s:make_state()
  autocmd BufWritePost <buffer> call delete('/tmp/inline.vim', 'rf')
augroup END

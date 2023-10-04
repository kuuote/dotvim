let s:cd = expand('<sfile>:p:h')

let g:vimrc_make_state_job = -1
function s:make_state() abort
  if exists('#dpp')
    call dpp#make_state('/tmp/dpp', s:cd .. '/conf/dpp.ts')
    return
  endif
  if has('nvim')
    call jobstop(g:vimrc_make_state_job)
    let g:vimrc_make_state_job = jobstart(['nvim', '--headless', '-u', s:cd .. '/makestate.vim'], {'stdin': 'null'})
  endif
endfunction

augroup new_vimrc
  autocmd! * <buffer>
  autocmd BufWritePost <buffer> call s:make_state()
  autocmd BufWritePost <buffer> call delete('/tmp/inline.vim', 'rf')
augroup END

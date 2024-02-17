if bufname() =~# '/\.git'
  finish
endif
augroup new_vimrc
  autocmd! * <buffer>
  autocmd BufWritePost <buffer> call delete('/tmp/inline.vim', 'rf')
  autocmd BufWritePost <buffer> call vimrc#dpp#makestate_job()
augroup END

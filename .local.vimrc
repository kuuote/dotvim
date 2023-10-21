augroup new_vimrc
  autocmd! * <buffer>
  autocmd BufWritePost <buffer> call vimrc#dpp#makestate_job()
  autocmd BufWritePost <buffer> call delete('/tmp/inline.vim', 'rf')
augroup END

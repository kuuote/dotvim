augroup vimrc_dup
  autocmd!
  autocmd BufWritePre * call vimrc#dup#save()
augroup END

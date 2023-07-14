augroup vimrc_snippets
  autocmd! * <buffer>
  execute printf('autocmd BufWritePost <buffer> call delete("%s")', expand('<sfile>:p:h') .. '/clean')
augroup END
if bufname() =~# 'toml$'
  set noexpandtab
endif

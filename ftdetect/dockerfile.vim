" Dockerfile.*を正しく認識させる
augroup filetypedetect
  autocmd BufNewFile,BufRead Dockerfile.* setf dockerfile
augroup END

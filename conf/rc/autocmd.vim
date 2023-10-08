" ディレクトリ無かったら掘る
autocmd BufWritePre * call vimrc#autocmd#auto_mkdir#do()

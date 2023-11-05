" 1 augroup宣言は大事
augroup vimrc

" シバン付いてるファイルに実行権限を与える
autocmd BufWritePost * call vimrc#autocmd#shebang#do()

" ディレクトリ無かったら掘る
autocmd BufWritePre * call vimrc#autocmd#auto_mkdir#do()

" 検索時だけhlsearchしてほしい
autocmd CmdlineEnter /,\? set hlsearch
autocmd CmdlineLeave /,\? set nohlsearch

" 終 augroupはちゃんと閉じるべし
augroup END


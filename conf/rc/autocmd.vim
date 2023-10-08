" 1 augroup宣言は大事
augroup vimrc

" ディレクトリ無かったら掘る
autocmd BufWritePre * call vimrc#autocmd#auto_mkdir#do()

" 検索時だけhlsearchしてほしい
autocmd CmdlineEnter /,\? set hlsearch
autocmd CmdlineLeave /,\? set nohlsearch

" 終 augroupはちゃんと閉じるべし
augroup END


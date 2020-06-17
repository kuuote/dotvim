" ウィンドウを切り替えたらターミナルジョブモードに突入するやつ
autocmd vimrc WinLeave * if &buftype ==# "terminal" | silent! execute "normal! i" | endif

" 後で消すハック
inoremap <expr> <C-c> tempcomment#expr()
command! DelComment call tempcomment#remove()

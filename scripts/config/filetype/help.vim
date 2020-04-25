set helplang=ja
"helpのタグ移動を楽にするやつ
augroup vimrc
  autocmd FileType help nnoremap <buffer> <CR> <C-]>
  autocmd FileType help nnoremap <buffer> <BS> <C-T>
augroup END

call minpac#add('lilydjwg/colorizer', {'type': 'opt'})

let g:colorizer_startup = v:false

" こちらはcolorizer側で上書きされる
nnoremap <silent> <Plug>Colorizer :<C-u>packadd colorizer<CR>:ColorToggle<CR>

let g:colorizer_nomap = v:true
" あちらでマップされるものと同じ
nmap <Leader>tc <Plug>Colorizer

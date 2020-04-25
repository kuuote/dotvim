call minpac#add('kuuote/vim-watermelon')

let g:watermelon_shellcomplete = v:true
let g:watermelon_chdir = v:true

autocmd vimrc User Watermelon nnoremap <buffer> <silent> R :<C-u>call watermelon#readrc()<CR>
autocmd vimrc User Watermelon nnoremap <buffer> <silent> W :<C-u>call watermelon#writerc()<CR>

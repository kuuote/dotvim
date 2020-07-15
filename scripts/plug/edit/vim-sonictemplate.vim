call minpac#add('mattn/vim-sonictemplate')

let g:sonictemplate_vim_template_dir = [$HOME .. "/.vim/template"]
" imap <Tab> <Plug>(sonictemplate-postfix)
autocmd vimrc FileType stpl setlocal noexpandtab

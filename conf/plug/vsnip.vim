if !dein#tap('vim-vsnip') | finish | endif
imap <Tab> <Plug>(vsnip-expand-or-jump)
let g:vsnip_snippet_dir = $HOME .. "/.vim/snippets"

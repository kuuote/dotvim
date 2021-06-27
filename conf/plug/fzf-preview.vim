UsePlugin fzf-preview.vim

nnoremap <fzf-p> <Nop>
map 'z <fzf-p>
nnoremap <silent> <fzf-p>f <Cmd>FzfPreviewCommandPaletteRpc<CR>
nnoremap <silent> <fzf-p>l <Cmd>FzfPreviewLinesRpc<CR>
nnoremap <silent> <fzf-p>s <Cmd>FzfPreviewGitStatusRpc<CR>
nnoremap <silent> <fzf-p>w <Cmd>FzfPreviewProjectMrwFilesRpc --add-fzf-arg=--no-sort<CR>

nnoremap <fzf-p> <Nop>
map ' <fzf-p>
nnoremap <silent> <fzf-p>w <Cmd>FzfPreviewProjectMrwFilesRpc --add-fzf-arg=--no-sort<CR>
nnoremap <silent> <fzf-p>s <Cmd>FzfPreviewGitStatusRpc<CR>

autocmd InsertEnter,CmdlineEnter * ++once source $VIMDIR/conf/rc/mappings/ic.vim

nnoremap <Space>. <Cmd>edit $VIMDIR/vimrc<CR>
nnoremap <Space>s <Cmd>update<CR>
nnoremap Q <Cmd>confirm qa<CR>
nnoremap <Space>d <Cmd>edit %:p:h<CR>
nnoremap tt <Cmd>tab split<CR>
nnoremap H <Cmd>tabprevious<CR>
nnoremap L <Cmd>tabnext<CR>
nnoremap tq <Cmd>tabclose<CR>
nnoremap <Space>j <PageDown>
nnoremap <Space>k <PageUp>
nnoremap <Space>w <C-w>

nnoremap ' :
nnoremap <Space>. <Cmd>edit $VIMDIR/vimrc<CR>
nnoremap <Space>d <Cmd>edit %:p:h<CR>
nnoremap <Space>j <PageDown>
nnoremap <Space>k <PageUp>
nnoremap <Space>s <Cmd>update<CR>
nnoremap <Space>w <C-w>
nnoremap H <Cmd>tabprevious<CR>
nnoremap L <Cmd>tabnext<CR>
nnoremap Q <Cmd>confirm qa<CR>
" 開く前の方向に戻っていく
nnoremap <expr> tq printf('<Cmd>tabclose <Bar> tabnext %d<CR>', max([1, tabpagenr() - 1]))

nnoremap tt <Cmd>tab split<CR>

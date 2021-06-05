" <Space> + j/k でPageDown/Up
nnoremap <Space>j <PageDown>
nnoremap <Space>k <PageUp>

" タブ関連
nnoremap <Space>tc <Cmd>tabclose<CR>
nnoremap <Space>ts <Cmd>tab split<CR>
nnoremap tt :tab split<CR>

" <C-l>にハイライト消去・ファイル変更適用効果を追加
" from https://github.com/takker99/dotfiles/blob/9ebeede1a43f7900c4c35e2d1af4c0468565bee9/nvim/userautoload/init/mapping.vim#L34-L35
nnoremap <C-l> :nohlsearch<CR>:checktime<CR><Esc><C-l>

" from https://github.com/aonemd/aaku/blob/0455967a9eae4abc7d66c6d2ce8059580d4b3cc5/vim/vimrc#L66
nnoremap ! :!

" from https://gist.github.com/tsukkee/1240267
onoremap ( t(

" short hand to window-down/up
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" sugoi undo
nnoremap U <C-r>

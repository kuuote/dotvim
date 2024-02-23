" 1 common
nnoremap ' :
nnoremap <Space>. <Cmd>edit $VIMDIR/vimrc<CR>
nnoremap <Space>d <Cmd>DduSelectorCall filer<CR>
nnoremap <Space>j <PageDown>
nnoremap <Space>k <PageUp>
nnoremap Q <Cmd>confirm qa<CR>

" shellのcd用ヘルパー
""/tmp/vim_shell_cdにカレントファイルのディレクトリパスを書き込んでVimを落とす
nnoremap <C-q> <Cmd>call writefile([expand('%:p:h')], '/tmp/vim_shell_cd')<CR><Cmd>confirm qa<CR>

" sugoi undo
nnoremap U <C-r>

" tab
nnoremap H <Cmd>tabprevious<CR>
nnoremap L <Cmd>tabnext<CR>
nnoremap tt <Cmd>tab split<CR>

" window movement
nnoremap <Space>w <C-w>
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l

" こまめなセーブは忘れずに
nnoremap <Space>s <Cmd>update<CR>

" 開く前の方向に戻っていく
nnoremap <expr> tq printf('<Cmd>tabclose <Bar> tabnext %d<CR>', max([1, tabpagenr() - 1]))


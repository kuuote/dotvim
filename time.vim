nnoremap 1 <Cmd>sort<CR>
nnoremap 2 <Cmd>sort /\s/<CR>
nnoremap 3 <Cmd>sort /\s\+\S\+\s\+\zs/<CR>

setglobal noswapfile
noswapfile e /tmp/time
set buftype=nofile

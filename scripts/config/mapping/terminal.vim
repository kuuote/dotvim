"escape from terminal when pressed 'fj'
tnoremap fj <C-\><C-n>

" Terminal boot
nnoremap <Space>te :<C-u>terminal ++curwin<CR>

" タブ移動するのに一々モード抜けるのしんどいので
tnoremap <C-f> <C-w>:<C-u>tabnext<CR>
tnoremap <C-b> <C-w>:<C-u>tabprevious<CR>

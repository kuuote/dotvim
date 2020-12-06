"shortcut to page <up|down>
nnoremap <Space>j <C-f>
nnoremap <Space>k <C-b>

" Ctrlキーは人間にやさしくない
nnoremap <Space>w <C-w>

" Scroll to cursor line at center of window when searching
nnoremap n nzz
nnoremap N Nzz

" *押した時にカーソルを戻す
" from monaqa's config
" nnoremap * *N
" nnoremap g* g*N
"
" from https://twitter.com/Bakudankun/status/1207057884581900289
nnoremap <silent><expr> * v:count ? '*'
\ : '<Cmd>sil keepj norm! *<CR><Cmd>call winrestview(' . string(winsaveview()) . ')<CR>'
nnoremap <silent><expr> g* v:count ? 'g*'
\ : '<Cmd>sil keepj norm! g*<CR><Cmd>call winrestview(' . string(winsaveview()) . ')<CR>'

" Pseudo page down by mouse click
nnoremap <RightMouse> z<CR>

" without shift from wass88 dotfiles
noremap <Space>h ^
noremap <Space>l g_

" 自分のいるfold以外を閉じる
" from monaqa's config
nnoremap <Space>z zMzv

" 楽にタグ移動がしたいっ
nnoremap <expr> <CR> empty(getcmdwintype()) && &buftype != "quickfix" ? "<C-]>" : "<CR>"

" Tab movements {{{

nnoremap <S-Tab> :<C-u>tabprevious<CR>
nnoremap <Tab> :<C-u>tabnext<CR>
nnoremap <Space>th :<C-u>tabprevious<CR>
nnoremap <Space>tl :<C-u>tabnext<CR>
nnoremap <Space>tn :<C-u>tabnew<CR>
nnoremap <Space>tq :<C-u>tabclose<CR>
nnoremap <Space>tQ :<C-u>tabclose!<CR>
nnoremap <Space>ts :<C-u>tab split<CR>
nnoremap <C-f> :<C-u>tabnext<CR>
nnoremap <C-b> :<C-u>tabprevious<CR>

" }}}

" vim: fdm=marker

call minpac#add('thinca/vim-quickrun')

nnoremap <silent> ' :<C-u>QuickRun -outputter multi:quickfix;open_cmd=:popup<CR>

" 都合上一緒に書いてるけどそのうちどっか移す
nnoremap <Space>' :<C-u>call vimrc#qftoggle()<CR>

call minpac#add('tyru/caw.vim', {'type': 'opt'})

nmap <SID>prefix <Plug>(caw:prefix)
xmap <SID>prefix <Plug>(caw:prefix)

nnoremap <script> gc :<C-u>packadd caw.vim<CR><SID>prefix
xnoremap <script> gc :<C-u>packadd caw.vim<CR><SID>prefix

call minpac#add('tyru/caw.vim', {'type': 'opt'})

nmap <SID>prefix <Plug>(caw:prefix)
xmap <SID>prefix <Plug>(caw:prefix)

function! s:load() abort
  packadd caw.vim
  nmap gc <Plug>(caw:prefix)
  xmap gc <Plug>(caw:prefix)
endfunction

nnoremap <silent> <script> gc :<C-u>call <SID>load()<CR><SID>prefix
xnoremap <silent> <script> gc :<C-u>call <SID>load()<CR>gv<SID>prefix

call minpac#add('tyru/caw.vim', {'type': 'opt'})

nmap <SID>prefix <Plug>(caw:prefix)
xmap <SID>prefix <Plug>(caw:prefix)
nnoremap <expr> <SID>load <SID>load_caw()
xnoremap <expr> <SID>load <SID>load_caw()

function! s:load_caw() abort
  packadd caw.vim
  nmap gc <Plug>(caw:prefix)
  xmap gc <Plug>(caw:prefix)
  return ""
endfunction

nnoremap <silent> <script> gc <SID>load<SID>prefix
xnoremap <silent> <script> gc <SID>load<SID>prefix

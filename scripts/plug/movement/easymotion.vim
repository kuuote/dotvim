call minpac#add('easymotion/vim-easymotion', {'type': 'opt'})

let g:EasyMotion_leader_key = '<Leader>s'
let g:EasyMotion_keys = 'asdfjkl;zxcvm,./'

nmap <SID>s2. <Plug>(easymotion-s2)
nmap <SID>s. <Plug>(easymotion-s)

nnoremap <script> <Leader>sw :<C-u>packadd vim-easymotion<CR><SID>s2.
nnoremap <script> <Leader>se :<C-u>packadd vim-easymotion<CR><SID>s.
function! s:highlight() abort
  silent hi link EasyMotionTarget Constant
  silent hi link EasyMotionTarget2First Identifier
  silent hi link EasyMotionTarget2Second Statement
endfunction

autocmd vimrc ColorScheme call s:highlight()

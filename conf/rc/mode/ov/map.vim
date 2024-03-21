" fake textobj-entire
onoremap ae <Cmd>normal! gg0vG$<CR>
xnoremap ae gg0oG$

" yank operation
"" L<denops-vimrc-yank>
xnoremap <CR> <Cmd>call vimrc#denops#request('yank', 'yank', [getregion(getpos('v'), getpos('.'), #{type: mode()})])<CR>:<C-u><Esc>


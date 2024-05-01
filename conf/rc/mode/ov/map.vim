" fake textobj-entire
onoremap ae <Cmd>normal! gg0vG$<CR>
xnoremap ae gg0oG$

" yank operation
"" L<denops-vimrc-yank>
xnoremap <CR> <Cmd>call vimrc#denops#notify('yank', 'yank', [getregion(getpos('v'), getpos('.'), #{type: mode()})])<CR>:<Esc>


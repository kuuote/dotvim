call minpac#add('mattn/vim-molder',{'type': 'opt'})
packadd vim-molder

let g:loaded_netrw = 1 " ~バギーなプラグインは無効化~

function! s:map_molder() abort
  nmap <buffer> <silent> <nowait> h <plug>(molder-up)
  nmap <buffer> <silent> <nowait> l <plug>(molder-open)
endfunction

autocmd FileType molder call s:map_molder()

nnoremap <Space>d :edit %:p:h<CR>

let g:molder_show_hidden = 1

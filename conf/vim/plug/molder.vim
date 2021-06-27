UsePlugin vim-molder

function! s:map_molder() abort
  nmap <buffer> <silent> <nowait> h <plug>(molder-up)
  nmap <buffer> <silent> <nowait> l <plug>(molder-open)
endfunction

autocmd FileType molder call s:map_molder()

let g:molder_show_hidden = 1

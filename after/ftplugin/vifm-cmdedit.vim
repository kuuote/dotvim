let g:old_cmdline = getline(1, "$")

function! s:only() abort
  let l = getline(".")
  call deletebufline("%", 1, "$")
  call setline(1, l)
endfunction

nnoremap <silent> <buffer> <Space>o :<C-u>call <SID>only()<CR>

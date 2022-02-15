let g:vim_indent_cont = 0
function! s:map_ft_vim() abort
  for n in [
  \ '<CR>',
  \ '<Down>',
  \ '<End>',
  \ '<Left>',
  \ '<Right>',
  \ '<SID>',
  \ '<Up>',
  \ '<buffer>',
  \ '<expr>',
  \ '<nowait>',
  \ '<script>',
  \ '<silent>',
  \ ]
    call hypermap#map('\' .. tolower(n[1:-2]), n, {'buffer': v:true})
  endfor
endfunction

call s:map_ft_vim()

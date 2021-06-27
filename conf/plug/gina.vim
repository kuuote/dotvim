UsePlugin gina.vim

call gina#custom#mapping#nmap(
      \ 'status', 'C',
      \ ':<C-u>Gina commit -v --opener=tabedit<CR>',
      \ {'noremap': 1, 'nowait': 1, 'silent': 1},
      \)

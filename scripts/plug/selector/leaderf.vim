if has("python3")
  call minpac#add('Yggdroot/LeaderF', {'type': 'opt'})
  call minpac#add('tamago324/LeaderF-filer', {'type': 'opt'})
  packadd LeaderF
  packadd LeaderF-filer
  nnoremap <Leader>F :<C-u>LeaderfFiler %:h<CR>
endif

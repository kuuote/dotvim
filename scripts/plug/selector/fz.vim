if executable("gof")
  call minpac#add('mattn/vim-fz', {'type': 'opt'})
  packadd vim-fz
  nnoremap <silent> <Space>yt :<C-u>call fz#sonictemplate#run()<CR>
endif

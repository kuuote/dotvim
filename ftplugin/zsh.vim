if bufname() =~# '/tmp/zsh.*zsh'
  set showtabline=2
  set tabline=%!getcwd()
  nnoremap <C-e> <Cmd>update<CR><Cmd>cquit 0<CR>
  inoremap <C-e> <Cmd>update<CR><Cmd>cquit 0<CR>
  call timer_start(0, {...->execute('startinsert!')})
endif

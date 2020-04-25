call minpac#add('tyru/notify-changed.vim', {'type': 'opt'})
if executable("notify-send")
  packadd notify-changed.vim
endif

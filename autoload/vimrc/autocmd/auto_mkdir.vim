function vimrc#autocmd#auto_mkdir#do() abort
  " auto mkdir
  let dir = expand('<afile>:p:h')
  if !isdirectory(dir)
    if confirm(dir .. ' is not found. create it?', "&Yes\n&No", 2) == 1
      call mkdir(dir, 'p')
    endif
  endif
endfunction

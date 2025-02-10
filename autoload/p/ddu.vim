function p#ddu#wait()
  let chars = ''
  while v:true
    let char = getcharstr(0)
    let chars ..= char
    sleep 1m
    if get(g:, 'vimrc#ddu#ready', v:false)
      break
    endif
  endwhile
  call feedkeys(chars, 'it')
endfunction

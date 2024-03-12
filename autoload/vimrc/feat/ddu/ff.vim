let s:uiready = v:false

function vimrc#feat#ddu#ff#wait_start(startfilter = v:false)
  let s:uiready = v:false
  augroup vimrc#feat#ddu#ff#wait_start
    autocmd!
    autocmd User Ddu:uiReady let s:uiready = v:true
  augroup END
  let chars = ''
  let startfilter = a:startfilter
  while v:true
    let char = getcharstr(0)
    if !startfilter && char ==# 'i'
      let startfilter = v:true
      let char = ''
    endif
    let chars ..= char
    sleep 1m
    if s:uiready
      break
    endif
  endwhile
  if startfilter
    " let chars = "\<Cmd>call ddu#ui#do_action('openFilterWindow')\<CR>" .. chars
    call timer_start(1, {->ddu#ui#do_action('openFilterWindow', {'input': chars})})
  else
    call feedkeys(chars, 'it')
  endif
endfunction

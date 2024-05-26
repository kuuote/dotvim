let s:uiready = v:false

function vimrc#feat#ddu#ff#filter(input = v:null)
  if has('nvim')
    autocmd vimrc CmdlineEnter @ ++once call cmdline#enable()
  endif
  let params = a:input is v:null ? {} : {'input': a:input}
  call ddu#ui#do_action('openFilterWindow', params)
endfunction

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
    " 詰まってる処理の後に差し込む
    call timer_start(1, {->vimrc#feat#ddu#ff#filter(chars)})
  else
    call feedkeys(chars, 'it')
  endif
endfunction

function vimrc#feat#ddu#ff#start(options, startfilter = v:false)
  call denops#plugin#wait('ddu')
  call ddu#start(a:options)
  call vimrc#feat#ddu#ff#wait_start(a:startfilter)
endfunction

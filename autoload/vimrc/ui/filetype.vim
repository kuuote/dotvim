let s:dir = expand('<sfile>:p:h') .. '/filetype'

function! vimrc#ui#filetype#menu() abort
  let files = readdir(s:dir)
  let menu = {}
  for f in files
    let m = matchlist(f, '\(\S\+\)\.vim')
    if !empty(m)
      let menu[m[1]] = ['eval', printf('vimrc#ui#filetype#%s#menu()', m[1])]
    endif
  endfor
  return menu
endfunction

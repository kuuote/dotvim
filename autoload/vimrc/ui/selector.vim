function! vimrc#ui#selector#menu() abort
  let files = readdir(g:dotvim .. '/autoload/selector/source')
  let menu = {}
  for f in files
    let m = matchlist(f, '\(\S\+\)\.vim')
    if !empty(m)
      let menu[m[1]] = printf('selector#source#%s#run()', m[1])
    endif
  endfor
  return menu
endfunction

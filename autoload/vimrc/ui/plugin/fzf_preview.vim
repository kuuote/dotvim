function! vimrc#ui#plugin#fzf_preview#menu() abort
  let menu = {}
  for c in getcompletion('', 'command')
    let m = matchlist(c, 'FzfPreview\(.*\)Rpc')
    if !empty(m)
      let menu[m[1]] = ':' .. m[0]
    endif
  endfor
  return menu
endfunction

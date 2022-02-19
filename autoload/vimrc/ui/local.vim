" buffer local menu

let s:defs = {}

function! vimrc#ui#local#register(id, condition, source) abort
  let s:defs[a:id] = [a:condition, a:source]
endfunction

function! vimrc#ui#local#menu() abort
  let menu = {}
  let availables = values(s:defs)
  \ ->filter('eval(v:val[0])')
  for m in availables
    let val = m[1]
    if type(val) == v:t_string
      let val = eval(val)
    endif
    for [name, result] in items(val)
      let menu[name] = result
    endfor
  endfor
  return menu
endfunction

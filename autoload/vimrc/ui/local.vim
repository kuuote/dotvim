" buffer local menu

function! vimrc#ui#local#register(id, condition, source) abort
  let b:ui_local = get(b:, 'ui_local', {})
  let b:ui_local[a:id] = [a:condition, a:source]
endfunction

function! vimrc#ui#local#menu() abort
  let menu = {}
  let availables = values(get(b:, 'ui_local', {}))
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

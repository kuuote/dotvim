let s:history = {'z': ['x', 'z']}

function! s:histadd(history, name) abort
  let s:history[a:history] = insert(filter(get(s:history, a:history, []), 'v:val !=# a:name'), a:name)
endfunction

function! s:sort(history, list) abort
  let h = get(s:history, a:history, [])
  let hi = {}
  for i in range(len(h))
    let k = h[i]
    if !has_key(hi, k)
      let hi[h[i]] = i
    endif
  endfor
  function! s:cmp(a, b) abort closure
    let ai = get(hi, a:a, -1)
    let bi = get(hi, a:b, -1)
    if ai == -1 && bi == -1
      return a:a < a:b ? -1 : 1
    elseif ai == -1
      return 1
    elseif bi == -1
      return -1
    else
      return ai - bi
    endif
  endfunction
  return sort(copy(a:list), funcref("s:cmp"))
endfunction

let s:main = json_decode(join(readfile(expand("<sfile>:p:h") .. "/ui.json")))

function! vimrc#ui#menu() abort
  let current = s:main
  let name = 'main'
  while v:true
    let list = s:sort(name, keys(current))
    let select = selector#run(list, 'exact')
    if empty(select)
      return
    endif
    call s:histadd(name, select)
    let result = get(current, select, v:null)
    if type(result) == v:t_dict
      let name ..= '.' .. select
      let current = result
      continue
    elseif type(result) == v:t_string
      if result[0] !=# ':'
        let result = 'eval ' .. result
      endif
      call histadd(':', result)
      execute result
    endif
    return
  endwhile
endfunction

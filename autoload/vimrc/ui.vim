function! s:assert_equals(expected, actual) abort
  if a:expected !=# a:actual
    throw printf('%s !=# %s', a:expected, a:actual)
  endif
endfunction

function! s:load() abort
  try
    let s:history = json_decode(join(readfile('/tmp/ui.json')))
    " assertion
    call s:assert_equals(v:t_dict, type(s:history))
    for v in values(s:history)
      call s:assert_equals(v:t_list, type(v))
      for vv in v
        call s:assert_equals(v:t_string, type(vv))
      endfor
    endfor
  catch
    echom string([v:exception, v:throwpoint])
    let s:history = {}
  endtry
endfunction
call s:load()

function! s:histadd(history, name) abort
  let s:history[a:history] = insert(filter(get(s:history, a:history, []), 'v:val !=# a:name'), a:name)
  call writefile([json_encode(s:history)], '/tmp/ui.json')
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
  return sort(copy(a:list), funcref('s:cmp'))
endfunction

let s:main = json_decode(join(readfile(expand('<sfile>:p:h') .. '/ui.json')))

function! vimrc#ui#menu() abort
  let current = s:main
  let name = 'main'
  while v:true
    let list = s:sort(name, keys(current))
    let select = selector#run(list, 'fzf')
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
      else
        let result = result[1:]
      endif
      call histadd(':', result)
      execute result
    elseif type(result) == v:t_list
      " eval result[1] as expr and using eval result as next menu
      if result[0] ==# 'eval'
        let evaluated = eval(result[1])
        if type(evaluated) == v:t_dict
          let name ..= '.' .. select
          let current = evaluated
          continue
        else
          throw evaluated
        endif
      endif
    endif
    return
  endwhile
endfunction

" hypermap.vim
" It provides non-blocking mapping at insert mode

" Usage:
"   hypermap#map(from, to[, {options}])
"
"     options:
"       "eval": evaluate to if true(same as `<expr>`)

let s:maps = {}

function! hypermap#map(from, to, ...) abort
  let key = a:from[-1:]
  let prefix = a:from[:-2]

  let map = get(s:maps, key, {})
  let s:maps[key] = map

  let opt = len(a:000) == 0 ? {} : a:1
  let map[prefix] = extend({'mapto': a:to, 'eval': v:false}, opt)
  execute 'inoremap' '<expr>' key 'hypermap#resolve("' .. key .. '")'
endfunction

function! hypermap#resolve(key) abort
  let line = getline('.')
  let lastidx = col('.') - 2
  for [map_prev, map] in items(get(s:maps, a:key, {}))
    let prev = line[max([0, lastidx - (len(map_prev) - 1)]):col('.') - 2]
    if prev ==# map_prev
      return repeat("\<BS>", len(map_prev)) .. (map.eval ? eval(map.mapto) : map.mapto)
    endif
  endfor
  return a:key
endfunction

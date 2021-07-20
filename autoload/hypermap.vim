" hypermap.vim
" It provides non-blocking mapping at insert mode

" Usage:
"   hypermap#map(from, to[, {options}])
"
"     options:
"       "eval": evaluate to if true(same as `<expr>`)
"       "mapmode": map to mode(default: ic)

let s:maps = {}

function! hypermap#map(from, to, ...) abort
  let key = a:from[-1:]
  let prefix = a:from[:-2]

  let map = get(s:maps, key, {})
  let s:maps[key] = map

  let opt = len(a:000) == 0 ? {} : a:1
  let newopt = extend({'mapto': a:to, 'mapmode': 'ic', 'eval': v:false}, opt)
  let map[prefix] = newopt
  if newopt.mapmode =~# 'i'
    execute 'inoremap' '<expr>' key 'hypermap#resolve("' .. key .. '")'
  endif
  if newopt.mapmode =~# 'c'
    execute 'cnoremap' key '<C-r>=hypermap#resolve("' .. key .. '")<CR>'
  endif
endfunction

function! s:getlinepos() abort
  if mode() ==# 'i'
    return [getline('.'), col('.') - 2]
  else
    return [getcmdline(), getcmdpos() - 2]
  endif
endfunction

function! hypermap#resolve(key) abort
  let [line, lastidx] = s:getlinepos()
  for [map_prev, map] in items(get(s:maps, a:key, {}))
    let prev = line[max([0, lastidx - (len(map_prev) - 1)]):col('.') - 2]
    if prev ==# map_prev
      return repeat("\<C-h>", len(map_prev)) .. (map.eval ? eval(map.mapto) : map.mapto)
    endif
  endfor
  return a:key
endfunction

" hypermap.vim
" It provides non-blocking mapping at insert mode
" Original idea from https://thinca.hatenablog.com/entry/20120716/1342374586

" Usage:
"   hypermap#map(from, to[, {options}])
"
"     options:
"       "eval": evaluate to if true(same as `<expr>`)
"       "mapmode": map to mode(default: ic)

let s:mapmode = {'ic': 'noremap!', 'i': 'inoremap', 'c': 'cnoremap'}

let s:maps = {}

" マッピングを分割することで<expr>の評価前に<Ignore>を適用する
" こうしないと処理落ち等で先行入力が結合されてしまった場合に正常動作しない
" 詳しくは:h map-exprを参照
noremap! <expr> <SID>(hypermap) hypermap#resolve(nr2char(getchar()))

function! hypermap#map(from, to, ...) abort
  let key = a:from[-1:]
  let prefix = list2str(reverse(str2list(a:from[:-2])))
  let opt = get(a:000, 0, {})

  let buffer = get(opt, 'buffer', v:false)

  if buffer
    let b:maps = get(b:, 'maps', {})
    let map = get(b:maps, key, {})
    let b:maps[key] = map
  else
    let map = get(s:maps, key, {})
    let s:maps[key] = map
  endif

  let newopt = extend({'mapto': a:to, 'mapmode': 'ic', 'eval': v:false}, opt)
  let map[prefix] = newopt
  execute s:mapmode[newopt.mapmode] (buffer ? '<buffer>' : '') '<script>' key '<Ignore><SID>(hypermap)' ..  key
endfunction

function! s:getline() abort
  let i = mode() ==# 'i'
  let pos = (i ? col('.') : getcmdpos()) - 2
  if pos == -1
    return ''
  endif
  return (i ? getline('.') : getcmdline())[:pos]
endfunction

function! hypermap#resolve(key) abort
  let line = list2str(reverse(str2list(s:getline())))
  let localmaps = get(b:, 'maps', {})
  let maps = extend(copy(get(localmaps, a:key, {})), get(s:maps, a:key, {}), 'keep')
  let matches = filter(items(maps), 'stridx(line, v:val[0]) == 0')
  call sort(matches, {a, b -> a[0] < b[0] ? -1 : 1})
  if !empty(matches)
    let [map_prev, map] = matches[-1]
    return repeat("\<C-h>", len(map_prev)) .. (map.eval ? eval(map.mapto) : map.mapto)
  endif
  return a:key
endfunction

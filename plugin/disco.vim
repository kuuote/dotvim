"Wikipediaの色相環の項目の虹色
const s:colors = ['FF0000', 'FF4000', 'FF8000', 'FFBF00', 'FFFF00', 'BFFF00', '80FF00', '40FF00', '00FF00', '00FF40', '00FF80', '00FFBF', '00FFFF', '00BFFF', '0080FF', '0040FF', '0000FF', '4000FF', '8000FF', 'BF00FF', 'FF00FF', 'FF00BF', 'FF0080', 'FF0040']

let s:cnt = 0
let s:timer = -1

function! s:paintline(line) abort
   call prop_clear(a:line)
  for i in range(1, len(getline(a:line)))
    call prop_add(a:line, i, {'type': s:colors[(a:line + i + s:cnt) % len(s:colors)]})
  endfor
endfunction

function! s:paint(start, end) abort
  for i in range(a:start, a:end)
    call s:paintline(i)
  endfor
endfunction

function! s:callback(...) abort
  let s:cnt += 1
  call s:paint(line('w0'), line('w$'))
endfunction

function! s:init() abort
  colorscheme industry
  for c in s:colors
    execute printf('hi %s guifg=#%s guibg=#000000', c, c)
    silent! call prop_type_add(c, {'highlight': c})
  endfor
  augroup discovim
    autocmd!
    autocmd TextChanged * call <SID>paint(line('w0'), line('w$'))
    autocmd TextChangedI * call <SID>paint(line('w0'), line('w$'))
  augroup END
  if s:timer != -1
    call timer_stop(s:timer)
  endif
  let s:timer = timer_start(50, funcref('s:callback'), {'repeat': -1})
  call s:callback()
endfunction

command! Disco call <SID>init() 

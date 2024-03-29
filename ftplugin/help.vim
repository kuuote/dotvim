nnoremap <buffer> <CR> <C-]>
nnoremap <buffer> <BS> <C-T>

function! s:midasi_right() abort
  let line = getline('.')
  let m = matchlist(line, '\v^(%(.+)\S)?\s*(\*.+\*)')
  call setline('.', m[1] .. repeat(' ', 78 - len(m[1]) - len(m[2])) .. m[2])
endfunction

" INTRODUCTION                                               *hoge-introduction*
" ↑みたいなやつを右寄せする
command! -buffer MidasiRight call s:midasi_right()


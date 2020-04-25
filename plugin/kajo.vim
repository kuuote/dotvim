function! s:partkindent() abort
  let l = getline(".")
  let i = matchstr(l, "\\v[\u3000]*・")
  return [i, l[len(i):-1]]
endfunction

function! s:getkindent(ic) abort
  if a:ic <= 0
    return ""
  else
    return repeat("\u3000", a:ic - 1) .. "・"
  endif
endfunction

function! s:kindent(incc) abort
  let v = winsaveview()
  let p = s:partkindent()
  let newic = strchars(p[0]) + a:incc
  call setline(line("."), s:getkindent(newic) .. p[1])
  let v.col += a:incc * 3 " Unicodeでは空白も点も3幅
  call winrestview(v)
endfunction

function! s:knewline(newposoff) abort
  let v = winsaveview()
  let ic = strchars(s:partkindent()[0])
  let newpos = max([0, line(".") + a:newposoff])
  let i = s:getkindent(ic)
  call append(max([0, newpos - 1]), i)
  let v.lnum = newpos
  let v.col = len(i)
  call winrestview(v)
endfunction

function! s:eskk_return() abort
  let feed = eskk#filter(eskk#util#key2char("<CR>"))
  call feedkeys(feed, "nx")

  return printf("\<C-o>:call %sknewline(1)\<CR>\<C-o>:call eskk#enable()\<CR>", matchstr(string(funcref("s:knewline")), "'\\zs.*_"))
endfunction

function! s:map_kajo() abort
  inoremap <buffer> <silent> <C-d> <C-o>:call <SID>kindent(-1)<CR>
  inoremap <buffer> <silent> <C-t> <C-o>:call <SID>kindent(1)<CR>
  inoremap <buffer> <silent> <CR> <C-o>:call <SID>knewline(1)<CR>
  nnoremap <buffer> <silent> O :<C-u>call <SID>knewline(0)<CR>A
  nnoremap <buffer> <silent> o :<C-u>call <SID>knewline(1)<CR>A
  augroup eskk_kajo_map
    autocmd!
    autocmd User eskk-enable-post lnoremap <buffer> <expr> <silent> <CR> <SID>eskk_return()
  augroup END
  echo "kajo mode on"
endfunction

command! Kajo call s:map_kajo()

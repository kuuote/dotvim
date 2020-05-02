const s:re = "^-\\|^*"
function! s:append() abort
  call append(0, "* ")
  call append(1, "")
  1
  startinsert!
endfunction

function! s:lift(direction) abort
  let cline = line(".")
  let sline = cline
  while sline > 0
    if getline(sline) =~# s:re
      break
    endif
    let sline -= 1
  endwhile
  let eline = sline + 1
  while eline <= line("$")
    if getline(eline) =~# s:re
      break
    endif
    let eline += 1
  endwhile
  let eline -= 1
  let pos = [cline - sline + 1, col(".")]
  let reg = map(range(sline, eline), "getline(v:val)")
  call deletebufline("%", sline, eline)
  if a:direction == 0 " ascend
    call append(0, reg)
  else " descend
    let pos[0] += line("$")
    call append(line("$"), reg)
  endif
    call cursor(pos[0], pos[1])
  write
endfunction

function! s:mark() abort
  let cline = line(".")
  while cline > 0
    let t = getline(cline)
    if t[0] == "-"
      call setline(cline, "*" .. t[1:])
      call s:lift(0)
      break
    elseif t[0] ==# "*"
      call setline(cline, "-" .. t[1:])
      call s:lift(1)
      break
    else
      let cline -= 1
    endif
  endwhile
  write
endfunction

function! s:sweep() abort
  let ps = []
  for l in range(1, line("$"))
    if getline(l) =~# s:re
      call insert(ps, l)
    endif
  endfor
  let last = line("$")
  for p in ps
    if getline(p)[0] ==# "-"
      call deletebufline("%", p, last)
    endif
    let last = p - 1
  endfor
  write
endfunction

function! QMIndent() abort
  return getline(v:lnum) =~# '\v^\s*(-|\*)' ? 0 : 2
endfunction

function! OpenQuickMemo() abort
  silent! noswapfile edit ~/.vim/quickmemo.txt
  nnoremap <buffer> <silent> <Leader>a :<C-u> call <SID>append()<CR>
  nnoremap <buffer> <silent> <Leader>l :<C-u> call <SID>lift(0)<CR>
  nnoremap <buffer> <silent> <Leader>m :<C-u> call <SID>mark()<CR>
  nnoremap <buffer> <silent> <Leader>s :<C-u> call <SID>sweep()<CR>
  setlocal indentexpr=QMIndent()
  syntax clear
  syntax match QMFavorite /^*/
  syntax match QMScratch /^-/
  hi! default link QMFavorite DiffAdd
  hi! default link QMScratch DiffDelete
  exe "silent doau ColorScheme" get(g:, "colors_name", "default")
  " swap無いとautoreadされない？
  let s:bufnr = bufnr("%")
  autocmd CursorMoved,CursorMovedI <buffer> checktime %
  autocmd TextChanged,TextChangedI <buffer> checktime %
endfunction

function! s:argc() abort
endfunction

function! s:empty_buffer() abort
  if exists("v:argv")
    return len(v:argv) == 1
  elseif filereadable("/proc/self/cmdline")
    return len(split(readfile("/proc/self/cmdline")[0])) == 1
  else 
    return bufname("%") ==# "" && argc() == 0 && wordcount().bytes == 0
  endif
endfunction

function! s:boot() abort
  if s:empty_buffer()
    call OpenQuickMemo()
  endif
endfunction

au VimEnter * call s:boot()

au ColorScheme seagull hi! link QMFavorite Error
au ColorScheme seagull hi! link QMScratch Constant

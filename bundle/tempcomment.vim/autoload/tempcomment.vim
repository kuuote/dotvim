let s:comment = '_後で消す_'
let s:commentlater = '_ここまで後で消す_'

function! s:on_save() abort
  let l:view = winsaveview()
  try
    call cursor(1, 1)
    if search(s:comment, 'c')
      echo '後で消すのでは？'
    endif
  finally
    call winrestview(l:view)
  endtry
endfunction

function! tempcomment#remove() abort
  let l:view = winsaveview()
  let l:poslist = []
  call cursor(1, 1)
  while v:true
    let l:start = search(s:comment, 'cW')
    if l:start == 0
      break
    endif
    let l:end = search(s:commentlater, 'cW')
    call add(l:poslist, [l:start, l:end])
  endwhile
  call winrestview(l:view)
  for [l:start, l:end] in reverse(l:poslist)
    call deletebufline('%', l:start, l:end)
  endfor
endfunction

function! tempcomment#init() abort
  augroup tempcomment
    autocmd!
    autocmd BufWritePost * call s:on_save()
  augroup END
endfunction

function! tempcomment#expr() abort
  call tempcomment#init()
  let l:start = printf(&l:commentstring, s:comment)
  let l:end = printf(&l:commentstring, s:commentlater)
  return l:start .. "\<CR>x\<C-u>" .. l:end .. "\<Esc>Ox\<C-u>"
endfunction

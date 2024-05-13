set nocompatible

function s:pagedown() abort
  let line = line('.')
  let topline = winsaveview().topline
  normal! L
  if line == line('.')
    " 末尾にいたらPageDown
    normal! ztL
  endif
  if line('.') == line('$')
    " 行末に来たらウィンドウの末尾と最下行を合わせる
    normal! z-
    if winsaveview().topline != topline
      " サクラエディタ風の挙動
      " 既に行末にいる場合以外は元の行末にカーソルを置く
      execute line
    else
    endif
  endif
  normal! 0
endfunction

function s:pageup() abort
  let line = line('.')
  let topline = winsaveview().topline
  normal! H
  if line == line('.')
    " 先頭にいたらPageUp
    normal! zbH
  endif
  let newtopline = winsaveview().topline
  if newtopline == 1 && topline != newtopline
    " 上と同じく
    execute line
  endif
  normal! 0
endfunction

function! s:align() abort
  let pos = getcurpos()[1:]
  let view = winsaveview()
  normal! gg
  while v:true
    let cl = line('.')
    if line('w0') <= pos[0] && pos[0] <= line('w$')
      call cursor(pos)
      return
    endif
    normal! Lzt
    if cl == line('.')
      call winrestview(view)
      echomsg 'wtf?'
    endif
  endwhile
endfunction

nnoremap + <Cmd>call <SID>align()<CR>
nnoremap - <Cmd>call <SID>pageup()<CR>
nnoremap @ <Cmd>call <SID>pagedown()<CR>
nnoremap Q <Cmd>cquit 0<CR>
runtime ftplugin/man.vim
nnoremap m :tab Man<Space>

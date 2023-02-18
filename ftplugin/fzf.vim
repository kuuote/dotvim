" Unite風に操作したい
" fzf-previewのgit statusのキーバインドに最適化している

function! s:pinsert()
  tmapclear <buffer>
  tnoremap <buffer> <nowait> <Esc> <Cmd>call <SID>init()<CR>
  " overwrite global mapping
  tnoremap <buffer> <nowait> f f
endfunction

function! s:init() abort
  tmapclear <buffer>
  for l:i in range(256)
    let l:c = nr2char(l:i)
    if l:c =~# '[[:graph:]]' && c !=# '|'
      execute printf('tnoremap <buffer> <nowait> %s <Nop>', l:c)
    endif
  endfor
  " pseudo input
  tnoremap <buffer> <nowait> i <Cmd>call <SID>pinsert()<CR>

  tnoremap <buffer> <nowait> q <Esc>
  " cursor
  tnoremap <buffer> <nowait> j <C-j>
  tnoremap <buffer> <nowait> k <C-k>
  " scroll
  tnoremap <buffer> <nowait> d <C-d>
  tnoremap <buffer> <nowait> u <C-u>
  " git
  tnoremap <buffer> <nowait> c <C-c>
  tnoremap <buffer> <nowait> h <C-a>
  tnoremap <buffer> <nowait> l <C-r>
endfunction

call timer_start(1, {->s:init()})

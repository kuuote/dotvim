let s:scissor = '# ------------------------ >8 ------------------------'
function! s:delete() abort
  call cursor(1, 1)
  call search(s:scissor)
  let scissorline = line('.') - 1
  let lines = getbufline('%', 1, '$')->filter('v:val !~# "^#" || v:key >= scissorline')
  call deletebufline('%', 1, '$')
  call setbufline('%', 1, lines)

  let log = systemlist('cd ' .. expand('%:p:h:h') .. ' ; git log --oneline')->map('"# " .. v:val')
  call appendbufline('%', '$', log)
endfunction

nnoremap <buffer> <CR>d <Cmd>call <SID>delete()<CR>
" VimでGin commitが上手く行かないのでwipe
set bufhidden=wipe

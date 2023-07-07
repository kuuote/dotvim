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
" diffのいい感じなパーサー入れてるしもういっそdiffでいい気がする
set filetype=diff

" .git/vimが実行できるならウィンドウ切って実行する
" コミットメッセージ打ってる間にチェックしたい

let s:exe = expand('%:p:h') .. '/vim'
let s:root = expand('%:p:h:h')

function s:killwin(winid)
  call win_gotoid(a:winid)
  " bdelete!
endfunction

if executable(s:exe)
  let win = win_getid()
  botright 10new
  let termwin = win_getid()
  execute 'lcd' s:root
  call termopen(s:exe)
  let termbuf = bufnr()
  normal! G
  call win_gotoid(win)

  execute printf('autocmd QuitPre <buffer> ++nested call win_execute(%d, "bdelete!")', termwin)
endif

" qfixhowm行儀が悪いので透過的に遅延ロードさせる
call minpac#add('fuenor/qfixhowm', {'type': 'opt'})

let s:leader = get(g:, "mapleader", "\\")
let s:map = "g" .. (empty(s:leader) ? "\\" : s:leader)

" g<Leader>が押されたらロードしてマッピングを送りなおす
function! s:load() abort
  packadd qfixhowm
  execute "unmap" s:map
  call feedkeys(s:map)
endfunction

nnoremap <silent> <nowait> g<Leader> :<C-u>call <SID>load()<CR>

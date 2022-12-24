command! -buffer Sortoml call denops#request('vimrc', 'blockSort', [1, line('$'), '..plugins]]', 'repo.*'])

" dein.vimのtomlのhook_addなどをparteditでいじるやつ
function! s:partedit() abort
  let view = winsaveview()
  let start = search('\v^%(hook|lua)_', 'bc')
  let end = search("^'''")
  if start == 0 || end == 0
    return
  endif
  call winrestview(view)
  let ft = getline(start) =~# 'lua' ? 'lua' : 'vim'
  execute printf('%d,%dPartedit -opener new -filetype %s', start + 1, end - 1, ft)
endfunction

nnoremap <buffer> mp <Cmd>call <SID>partedit()<CR>

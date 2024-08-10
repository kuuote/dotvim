" syntax大事
" getline hack from https://github.com/4513ECHO/dotfiles/blob/c0a0bff2186d38aca9674ac30615c672b1b96c92/config/nvim/dein/ftplugin.toml?plain=1#L104
if getline(1) =~# '\v^(\[\[plugins]]|hook_)'
  call timer_start(1, {->dpp#ext#toml#syntax()})
endif

" dein.vimのtomlのhook_addなどをparteditでいじるやつ
function! s:partedit() abort
  let view = winsaveview()
  let start = search("\\v^%(hook|lua)_.*'''$", 'bc')
  let end = search("^'''")
  if start == 0 || end == 0
    return
  endif
  call winrestview(view)
  let ft = getline(start) =~# 'lua' ? 'lua' : 'vim'
  execute printf('%d,%dPartedit -opener new -filetype %s', start + 1, end - 1, ft)
endfunction

nnoremap <buffer> mp <Cmd>call <SID>partedit()<CR>

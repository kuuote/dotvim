call minpac#add('vimwiki/vimwiki',{'type': 'opt'})

function! s:load_vimwiki() abort
  packadd vimwiki
  execute "VimwikiIndex"
endfunction

nnoremap <silent> <Leader>ww :<C-u>call <SID>load_vimwiki()<CR>

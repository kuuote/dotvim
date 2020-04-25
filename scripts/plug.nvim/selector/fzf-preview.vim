call minpac#add('yuki-ycino/fzf-preview.vim', {'type': 'opt'})
packadd fzf-preview.vim
packadd gina.vim
try
  call gina#custom#mapping#nmap(
        \ 'status', 'p',
        \ ':FzfPreviewGitStatus<CR>',
        \ {'silent': 1, 'nowait': 1},
        \)
catch
  call vimrc#add_exception()
endtry

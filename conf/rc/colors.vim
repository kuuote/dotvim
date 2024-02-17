nnoremap cs <Cmd>source $VIMDIR/conf/rc/colors/select.vim<CR>
set termguicolors
try
  augroup persistent_colorscheme
    autocmd!
  augroup END
  source /tmp/colors.vim
catch
endtry

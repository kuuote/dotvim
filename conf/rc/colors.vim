nnoremap cs <Cmd>source $VIMDIR/conf/rc/colors/select.vim<CR>
set termguicolors
try
  source /tmp/colors.vim
catch
  set background=light
  colorscheme aomi-grayscale
endtry

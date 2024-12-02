nnoremap cs <Cmd>source $MYVIMDIR/conf/rc/colors/select.vim<CR>
set termguicolors

function s:persistent_colorscheme() abort
  try
    augroup persistent_colorscheme
      autocmd!
    augroup END
    source /tmp/colors.vim
  catch
    let g:persistent_colorscheme_error = [v:exception, v:throwpoint]
    try
      source $MYVIMDIR/conf/rc/colors/def/catppuccin-mocha_transparent.vim
    catch
    endtry
  endtry
endfunction

autocmd vimrc VimEnter * ++nested call s:persistent_colorscheme()

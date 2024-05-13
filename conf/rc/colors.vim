nnoremap cs <Cmd>source $VIMDIR/conf/rc/colors/select.vim<CR>
set termguicolors

function s:persistent_colorscheme() abort
  try
    augroup persistent_colorscheme
      autocmd!
    augroup END
    source /tmp/colors.vim
  catch
    let g:persistent_colorscheme_error = [v:exception, v:throwpoint]
  endtry
endfunction

autocmd vimrc VimEnter * ++nested call s:persistent_colorscheme()

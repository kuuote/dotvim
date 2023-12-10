source $VIMDIR/conf/rc/colors/def/common/transparent.vim
function s:autocmd() abort
  hi Comment guifg=white gui=undercurl
endfunction
autocmd persistent_colorscheme ColorScheme catppuccin call s:autocmd()
source $VIMDIR/conf/rc/colors/def/catppuccin-mocha.vim

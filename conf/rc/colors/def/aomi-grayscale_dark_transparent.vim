source $MYVIMDIR/conf/rc/colors/def/common/transparent.vim

function s:on_colorscheme() abort
  hi Constant guibg=NONE
  hi Identifier guibg=NONE
  hi Special guibg=NONE
  hi Title guibg=NONE
  hi Type guibg=NONE
endfunction
autocmd persistent_colorscheme ColorScheme aomi-grayscale call s:on_colorscheme()

source $MYVIMDIR/conf/rc/colors/def/aomi-grayscale_dark.vim


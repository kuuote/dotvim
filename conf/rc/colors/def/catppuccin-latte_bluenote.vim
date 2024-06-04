function s:on_colors() abort
  hi Normal guifg=#6060ff
  hi Pmenu guibg=#e0e0ff guifg=#6060ff
  hi PmenuSel guifg=#ff6060 guibg=#ffe8e8
  hi NormalFloat guibg=#e0e0ff guifg=#6060ff
  hi CmpItemAbbr guifg=#6060ff
  hi CmpItemKindText guifg=#6060ff
  hi PumHighlight ctermfg=205 ctermbg=225 guifg=#ff60c0 guibg=#ffd0ff cterm=NONE gui=NONE

  hi DduFloat guibg=NONE
  hi DduEnd guibg=NONE
  if has('nvim')
    hi @variable guifg=#6060ff
  endif
endfunction

autocmd persistent_colorscheme ColorScheme catppuccin-latte call s:on_colors()

source $VIMDIR/conf/rc/colors/def/catppuccin-latte.vim

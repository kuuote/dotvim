source $DOTVIM/persist/def/catppuccin-latte.vim
hi Normal guifg=#6060ff
hi Pmenu guibg=#e0e0ff guifg=#6060ff
hi PmenuSel guifg=#ff6060 guibg=#ffe8e8
hi NormalFloat guibg=#e0e0ff guifg=#6060ff
hi CmpItemAbbr guifg=#6060ff
hi CmpItemKindText guifg=#6060ff
hi FuzzyAccent ctermfg=205 ctermbg=225 guifg=#ff60c0 guibg=#ffd0ff cterm=NONE gui=NONE

hi DduFloat guibg=None
hi DduEnd guibg=None

if has('nvim')
  hi @variable guifg=#6060ff
endif

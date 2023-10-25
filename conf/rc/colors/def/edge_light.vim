set background=light
colorscheme edge
hi Pmenu guibg=#e0e0ff guifg=#6060ff
hi PmenuSel guifg=#ff6060 guibg=#ffe8e8
hi NormalFloat guibg=#e0e0ff guifg=#6060ff
hi CmpItemAbbr guifg=#6060ff
hi CmpItemKindText guifg=#6060ff
hi PumHighlight ctermfg=205 ctermbg=225 guifg=#ff60c0 guibg=#ffd0ff cterm=NONE gui=NONE

if has('nvim')
	hi link @text.diff.indicator PmenuSbar
endif

let s:palette = edge#get_palette('light', 0, {})
"execute 'hi FuzzyMotionChar guifg=' .. s:palette.purple[0]
execute 'hi FuzzyMotionSubChar guifg=' .. s:palette.green[0]
execute 'hi FuzzyMotionMatch guibg=' .. s:palette.diff_green[0]
execute 'hi FuzzyMotionShade guifg=' .. s:palette.grey_dim[0]

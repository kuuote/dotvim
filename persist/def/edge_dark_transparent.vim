set background=dark
colorscheme edge
hi Normal guibg=NONE
hi EndOfBuffer guibg=NONE

let s:palette = edge#get_palette('default', 0, {})
execute 'hi FuzzyAccent guifg=' .. s:palette.blue[0]
execute 'hi FuzzyMotionChar guifg=' .. s:palette.purple[0]
execute 'hi FuzzyMotionSubChar guifg=' .. s:palette.green[0]
execute 'hi FuzzyMotionMatch guifg=' .. s:palette.blue[0]
execute 'hi FuzzyMotionShade guifg=' .. s:palette.grey_dim[0]

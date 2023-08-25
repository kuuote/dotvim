set background=dark
colorscheme edge

let s:palette = edge#get_palette('default', 0, {})
execute 'hi PumHighlight guifg=' .. s:palette.blue[0]
execute 'hi FuzzyMotionChar guifg=' .. s:palette.purple[0]
execute 'hi FuzzyMotionSubChar guifg=' .. s:palette.green[0]
execute 'hi FuzzyMotionMatch guifg=' .. s:palette.blue[0]
execute 'hi FuzzyMotionShade guifg=' .. s:palette.grey_dim[0]

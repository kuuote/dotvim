" Name: bluenote256
" Author: kuuote <znmxodq1@gmail.com>

hi clear
if exists("syntax_on")
  syntax reset
endif

set background=light
let g:colors_name = "bluenote256"
let g:bluenote_terminal = get(g:, "bluenote_terminal", v:true)
let g:bluenote_rainbow_level = get(g:, "bluenote_rainbow_level", 1)

hi Comment ctermfg=147 ctermbg=NONE guifg=#a0a0ff guibg=NONE cterm=NONE gui=NONE
hi Constant ctermfg=210 ctermbg=NONE guifg=#ff8080 guibg=NONE cterm=NONE gui=NONE
hi Cursor ctermfg=120 ctermbg=205 guifg=#80ff80 guibg=#ff60c0 cterm=NONE gui=NONE
hi CursorLineNr ctermfg=205 ctermbg=225 guifg=#ff60c0 guibg=#ffd0ff cterm=NONE gui=NONE
hi DiffAdd ctermfg=NONE ctermbg=157 guifg=NONE guibg=#a0ffa0 cterm=NONE gui=NONE
hi DiffChange ctermfg=NONE ctermbg=159 guifg=NONE guibg=#a0ffff cterm=NONE gui=NONE
hi DiffDelete ctermfg=NONE ctermbg=217 guifg=NONE guibg=#ffc0c0 cterm=NONE gui=NONE
hi DiffText ctermfg=NONE ctermbg=228 guifg=NONE guibg=#ffff80 cterm=NONE gui=NONE
hi Directory ctermfg=205 ctermbg=NONE guifg=#ff60c0 guibg=NONE cterm=bold gui=bold
hi EasyMotionTarget ctermfg=120 ctermbg=105 guifg=#80ff80 guibg=#8080ff cterm=NONE gui=NONE
hi EasyMotionTarget2First ctermfg=123 ctermbg=210 guifg=#80ffff guibg=#ff8080 cterm=NONE gui=NONE
hi EasyMotionTarget2Second ctermfg=120 ctermbg=213 guifg=#80ff80 guibg=#ff80ff cterm=NONE gui=NONE
hi Error ctermfg=210 ctermbg=228 guifg=#ff8080 guibg=#ffff80 cterm=NONE gui=NONE
hi FoldColumn ctermfg=123 ctermbg=239 guifg=#80ffff guibg=#555555 cterm=NONE gui=NONE
hi Folded ctermfg=123 ctermbg=239 guifg=#80ffff guibg=#555555 cterm=NONE gui=NONE
hi Identifier ctermfg=213 ctermbg=NONE guifg=#ff80ff guibg=NONE cterm=NONE gui=NONE
hi Ignore ctermfg=239 ctermbg=NONE guifg=#555555 guibg=NONE cterm=NONE gui=NONE
hi IncSearch ctermfg=120 ctermbg=63 guifg=#80ff80 guibg=#6060ff cterm=NONE gui=NONE
hi LineNr ctermfg=63 ctermbg=189 guifg=#6060ff guibg=#d0d0ff cterm=NONE gui=NONE
hi MatchParen ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE cterm=underline gui=underline
hi ModeMsg ctermfg=205 ctermbg=NONE guifg=#ff60c0 guibg=NONE cterm=NONE gui=NONE
hi MoreMsg ctermfg=34 ctermbg=NONE guifg=#00c000 guibg=NONE cterm=NONE gui=NONE
hi Normal ctermfg=63 ctermbg=254 guifg=#6060ff guibg=#f0f0f0 cterm=NONE gui=NONE
hi Pmenu ctermfg=63 ctermbg=120 guifg=#6060ff guibg=#80ff80 cterm=NONE gui=NONE
hi PmenuSbar ctermfg=NONE ctermbg=147 guifg=NONE guibg=#a0a0ff cterm=NONE gui=NONE
hi PmenuSel ctermfg=63 ctermbg=213 guifg=#6060ff guibg=#ff80ff cterm=NONE gui=NONE
hi PmenuThumb ctermfg=NONE ctermbg=63 guifg=NONE guibg=#6060ff cterm=NONE gui=NONE
hi PreProc ctermfg=34 ctermbg=NONE guifg=#00c000 guibg=NONE cterm=NONE gui=NONE
hi Question ctermfg=213 ctermbg=NONE guifg=#ff80ff guibg=NONE cterm=NONE gui=NONE
hi Search ctermfg=105 ctermbg=228 guifg=#8080ff guibg=#ffff80 cterm=NONE gui=NONE
hi Special ctermfg=196 ctermbg=NONE guifg=#ff0000 guibg=NONE cterm=NONE gui=NONE
hi SpecialKey ctermfg=196 ctermbg=NONE guifg=#ff0000 guibg=NONE cterm=NONE gui=NONE
hi Statement ctermfg=205 ctermbg=NONE guifg=#ff60c0 guibg=NONE cterm=bold gui=bold
hi StatusLineTerm ctermfg=210 ctermbg=254 guifg=#ff8080 guibg=#f0f0f0 cterm=bold,reverse gui=bold,reverse
hi StatusLineTermNC ctermfg=210 ctermbg=254 guifg=#ff8080 guibg=#f0f0f0 cterm=reverse gui=reverse
hi Todo ctermfg=210 ctermbg=123 guifg=#ff8080 guibg=#80ffff cterm=NONE gui=NONE
hi Type ctermfg=141 ctermbg=NONE guifg=#a080ff guibg=NONE cterm=bold gui=bold
hi Underlined ctermfg=210 ctermbg=NONE guifg=#ff8080 guibg=NONE cterm=underline gui=underline
hi VertSplit ctermfg=105 ctermbg=105 guifg=#8080ff guibg=#8080ff cterm=NONE gui=NONE
hi Visual ctermfg=254 ctermbg=105 guifg=#f0f0f0 guibg=#8080ff cterm=NONE gui=NONE
hi WarningMsg ctermfg=123 ctermbg=210 guifg=#80ffff guibg=#ff8080 cterm=NONE gui=NONE
hi WildMenu ctermfg=63 ctermbg=228 guifg=#6060ff guibg=#ffff80 cterm=NONE gui=NONE
hi! link ErrorMsg WarningMsg
hi! link NonText Normal
hi! link Title Constant
hi! link diffAdded DiffAdd
hi! link diffRemoved DiffDelete

if g:bluenote_rainbow_level == 1
let g:nglisp = {"parenlevel": 16}
hi NGLispParentheses10 ctermfg=63 ctermbg=228 guifg=#6060ff guibg=#ffff80 cterm=NONE gui=NONE
hi NGLispParentheses11 ctermfg=63 ctermbg=123 guifg=#6060ff guibg=#80ffff cterm=NONE gui=NONE
hi NGLispParentheses12 ctermfg=123 ctermbg=210 guifg=#80ffff guibg=#ff8080 cterm=NONE gui=NONE
hi NGLispParentheses13 ctermfg=63 ctermbg=228 guifg=#6060ff guibg=#ffff80 cterm=NONE gui=NONE
hi NGLispParentheses14 ctermfg=228 ctermbg=147 guifg=#ffff80 guibg=#a0a0ff cterm=NONE gui=NONE
hi NGLispParentheses15 ctermfg=120 ctermbg=213 guifg=#80ff80 guibg=#ff80ff cterm=NONE gui=NONE
hi NGLispParentheses16 ctermfg=63 ctermbg=120 guifg=#6060ff guibg=#80ff80 cterm=NONE gui=NONE
hi NGLispParentheses8 ctermfg=120 ctermbg=246 guifg=#80ff80 guibg=#a0a0a0 cterm=NONE gui=NONE
hi NGLispParentheses9 ctermfg=120 ctermbg=105 guifg=#80ff80 guibg=#8080ff cterm=NONE gui=NONE
endif
hi! link NGLispParentheses1 NGLispParentheses13
hi! link NGLispParentheses2 NGLispParentheses15
hi! link NGLispParentheses3 NGLispParentheses8
hi! link NGLispParentheses4 NGLispParentheses10
hi! link NGLispParentheses5 NGLispParentheses12
hi! link NGLispParentheses6 NGLispParentheses14
hi! link NGLispParentheses7 NGLispParentheses16

if g:bluenote_terminal
  let g:terminal_ansi_colors = ['#6060ff','#ff8080','#00c000','#ff60c0','#6060ff','#ff80ff','#a0a0ff','#f0f0f0','#6060ff','#ff8080','#00c000','#ff60c0','#6060ff','#ff80ff','#a0a0ff','#f0f0f0']

    for i in range(16)
      let g:terminal_color_{i} = g:terminal_ansi_colors[i]
    endfor

    function! s:uncolors() abort
      unlet g:terminal_ansi_colors
      for i in range(16)
        unlet g:terminal_color_{i}
      endfor
    endfunction

  augroup colorscheme_bluenote
    autocmd ColorSchemePre * call s:uncolors()
    autocmd ColorSchemePre * autocmd! colorscheme_bluenote
  augroup END
endif

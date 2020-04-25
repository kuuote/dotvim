" Vim color file
" Maintainer: Henry So, Jr. <henryso@panix.com>

" These are the colors of the "desert" theme by Hans Fugal with a few small
" modifications (namely that I lowered the intensity of the normal white and
" made the normal and nontext backgrounds black), modified to work with 88-
" and 256-color xterms.
"
" The original "desert" theme is available as part of the vim distribution or
" at http://hans.fugal.net/vim/colors/.
"
" The real feature of this color scheme, with a wink to the "inkpot" theme, is
" the programmatic approximation of the gui colors to the palettes of 88- and
" 256- color xterms.  The functions that do this (folded away, for
" readability) are calibrated to the colors used for Thomas E. Dickey's xterm
" (version 200), which is available at http://dickey.his.com/xterm/xterm.html.
"
" I struggled with trying to parse the rgb.txt file to avoid the necessity of
" converting color names to #rrggbb form, but decided it was just not worth
" the effort.  Maybe someone seeing this may decide otherwise...

let s:blue1 = "6060ff"
let s:cyan = "80ffff"
let s:lightgreen = "80ff80"
let s:thinwhite = "f0f0f0"
let s:darkgray = "555555"
let s:blue2 = "8080ff"
let s:thingray = "a0a0a0"
let s:pink = "ff80ff"
let s:red1 = "ff8080"
let s:yellow = "ffff80"
let s:red2 = "ff6060"
let s:pink2 = "ff60c0"
let s:darkgreen = "00c000"
let s:purple = "a080ff"
let s:thinblue = "a0a0ff"
let s:thinblue2 = "c0c0ff"
let s:red2 = "ff0000"
let s:thinred = "ffe0e0"

set background=light
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="blu"

if has("gui_running") || &t_Co >= 88
    " functions {{{
    " returns an approximate grey index for the given grey level
    fun! <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual grey level represented by the grey index
    fun! <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " returns the palette index for the given grey index
    fun! <SID>grey_color(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " returns an approximate color index for the given color level
    fun! <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual color level for the given color index
    fun! <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " returns the palette index for the given R/G/B color indices
    fun! <SID>rgb_color(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " returns the palette index to approximate the given R/G/B color levels
    fun! <SID>color(r, g, b)
        " get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " get the closest color
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " there are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " use the grey
                return <SID>grey_color(l:gx)
            else
                " use the color
                return <SID>rgb_color(l:x, l:y, l:z)
            endif
        else
            " only one possibility
            return <SID>rgb_color(l:x, l:y, l:z)
        endif
    endfun

    " returns the palette index to approximate the 'rrggbb' hex string
    fun! <SID>rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>color(l:r, l:g, l:b)
    endfun

    " sets the highlighting for the given group
    fun! <SID>X(group, fg, bg, attr)
        if a:fg != ""
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
        endif
        if a:bg != ""
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
        endif
        if a:attr != ""
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
    endfun
    " }}}

    call <SID>X("Normal", s:blue1, s:thinwhite, "")

    " highlight groups
    call <SID>X("Cursor", s:lightgreen, s:blue2, "")
    call <SID>X("lCursor", s:lightgreen, s:blue2, "")
    hi MatchParen ctermbg=NONE guibg=NONE
    call <SID>X("MatchParen", "", "", "underline")
    call <SID>X("DiffAdd", "", s:lightgreen, "")
    call <SID>X("DiffChange", "", s:cyan, "")
    call <SID>X("DiffDelete", "", s:red2, "")
    call <SID>X("DiffText", "", s:yellow, "")
    call <SID>X("VertSplit", s:blue2, s:blue2, "reverse")
    call <SID>X("Folded", s:cyan, s:darkgray, "")
    call <SID>X("FoldColumn", s:cyan, s:darkgray, "")
    call <SID>X("IncSearch", s:lightgreen, s:blue1, "")
    call <SID>X("LineNr", s:cyan, s:darkgray, "")
    call <SID>X("CursorLineNr", s:lightgreen, s:thingray, "")
    call <SID>X("ModeMsg", s:pink2, "", "")
    call <SID>X("MoreMsg", s:darkgreen, "", "")
    hi! link NonText Normal
    call <SID>X("Question", s:pink, "", "")
    call <SID>X("Search", s:blue2, s:yellow, "")
    call <SID>X("SpecialKey", s:red2, "", "")
    hi! link Title Constant
    call <SID>X("Visual", s:thinwhite, s:blue2, "")
    call <SID>X("WarningMsg", s:cyan, s:red1, "")
    hi! link ErrorMsg WarningMsg
    call <SID>X("WildMenu", s:blue1, s:yellow, "")
    call <SID>X("Pmenu", s:blue1, s:lightgreen, "")
    call <SID>X("PmenuSel", s:blue1, s:pink, "")
    call <SID>X("PmenuSbar", "", s:thinblue, "")
    call <SID>X("PmenuThumb", "", s:blue1, "")

    " syntax highlighting groups
    call <SID>X("Comment", s:thinblue, "", "")
    hi clear Constant
    call <SID>X("Constant", s:red1, s:thinred, "")
    call <SID>X("Identifier", s:darkgreen, "c0ffc0", "bold")
    call <SID>X("Statement", s:pink2, "ffd0ff", "none")
    call <SID>X("PreProc", s:pink2, "", "")
    call <SID>X("Type", s:purple, "", "bold")
    call <SID>X("Special", s:red2, "", "")
    call <SID>X("Underlined", s:red1, "", "underline")
    call <SID>X("Ignore", s:darkgray, "", "")
    "Error
    call <SID>X("Error", s:red1, s:yellow, "")
    call <SID>X("Todo", s:red1, s:cyan, "")

    let g:nglisp = {"parenlevel": 3}
    call <SID>X("NGLispParentheses1", "", s:yellow, "")
    call <SID>X("NGLispParentheses2", "", s:thinblue2, "")
    call <SID>X("NGLispParentheses3", "", s:lightgreen, "")

    "easy motion plugin
    call <SID>X("EasyMotionTarget", s:lightgreen, s:blue2, "")
    call <SID>X("EasyMotionTarget2First", s:cyan, s:red1, "")
    call <SID>X("EasyMotionTarget2Second", s:lightgreen, s:pink, "")

    " delete functions {{{
    delf <SID>X
    delf <SID>rgb
    delf <SID>color
    delf <SID>rgb_color
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_color
    delf <SID>grey_level
    delf <SID>grey_number
    " }}}
else
    " color terminal definitions
    hi SpecialKey    ctermfg=darkgreen
    hi NonText       cterm=bold ctermfg=darkblue
    hi Directory     ctermfg=darkcyan
    hi ErrorMsg      cterm=bold ctermfg=7 ctermbg=1
    hi IncSearch     cterm=NONE ctermfg=yellow ctermbg=green
    hi Search        cterm=NONE ctermfg=grey ctermbg=blue
    hi MoreMsg       ctermfg=darkgreen
    hi ModeMsg       cterm=NONE ctermfg=brown
    hi LineNr        ctermfg=3
    hi Question      ctermfg=green
    hi StatusLine    cterm=bold,reverse
    hi StatusLineNC  cterm=reverse
    hi VertSplit     cterm=reverse
    hi Title         ctermfg=5
    hi Visual        cterm=reverse
    hi VisualNOS     cterm=bold,underline
    hi WarningMsg    ctermfg=1
    hi WildMenu      ctermfg=0 ctermbg=3
    hi Folded        ctermfg=darkgrey ctermbg=NONE
    hi FoldColumn    ctermfg=darkgrey ctermbg=NONE
    hi DiffAdd       ctermbg=4
    hi DiffChange    ctermbg=5
    hi DiffDelete    cterm=bold ctermfg=4 ctermbg=6
    hi DiffText      cterm=bold ctermbg=1
    hi Comment       ctermfg=darkcyan
    hi Constant      ctermfg=brown
    hi Special       ctermfg=5
    hi Identifier    ctermfg=6
    hi Statement     ctermfg=3
    hi PreProc       ctermfg=5
    hi Type          ctermfg=2
    hi Underlined    cterm=underline ctermfg=5
    hi Ignore        ctermfg=darkgrey
    hi Error         cterm=bold ctermfg=7 ctermbg=1
endif

" vim: set fdl=0 fdm=marker:

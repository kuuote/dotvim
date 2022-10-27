call ddu#custom#alias('filter', 'matcher_fzf_nosort', 'matcher_fzf')

let s:config_json =<< UNKO

{
  "filterParams": {
    "matcher_fzf": {
      "highlightMatched": "DduMatch"
    },
    "matcher_fzf_nosort": {
      "highlightMatched": "DduMatch",
      "sort": 0
    }
  },
  "kindOptions": {
    "command": {
      "defaultAction": "execute"
    },
    "dein_update": {
      "defaultAction": "viewDiff"
    },
    "file": {
      "defaultAction": "open"
    },
    "help": {
      "defaultAction": "tabopen"
    },
    "source": {
      "defaultAction": "execute"
    },
    "word": {
      "defaultAction": "append"
    }
  },
  "sourceOptions": {
    "_": {
      "ignoreCase": true,
      "matchers": [
        "matcher_fzf"
      ]
    },
    "dein_update": {
      "matchers": [
        "matcher_dein_update"
      ]
    },
    "file": {
      "matchers": [
        "matcher_fuse"
      ]
    },
    "mr": {
      "matchers": [
        "matcher_fzf_nosort"
      ]
    }
  },
  "ui": "ff",
  "uiParams": {
    "ff": {
      "highlights": {
        "floating": "NormalFloat:DduFloat,CursorLine:DduCursorLine"
      },
      "previewFloatingZindex": 100,
      "previewVertical": true
    }
  }
}

UNKO

let s:config = s:config_json->join('')->json_decode()

" border idea by @eetann

let s:config['uiParams']['ff']['floatingBorder'] = ['.', '.', '.', ':', ':', '.', ':', ':']->map('[v:val, "DduBorder"]')
let s:config['uiParams']['ff']['split'] = has('nvim') ? 'floating' : 'horizontal'
let s:config['uiParams']['ff']['previewFloating'] = has('nvim')
let s:config['uiParams']['ff']['previewFloatingBorder'] = ['.', '.', '.', ':', ':', '.', ':', ':']->map('[v:val, "DduBorder"]')

function! s:set_size() abort
  let winCol = &columns / 8
  let winWidth = &columns - (&columns / 4)
  let winRow = &lines / 8
  let winHeight = &lines - (&lines / 4)
  let s:config['uiParams']['ff']['winCol'] = winCol
  let s:config['uiParams']['ff']['winWidth'] = winWidth
  let s:config['uiParams']['ff']['winRow'] = winRow
  let s:config['uiParams']['ff']['winHeight'] = winHeight

  " fzf-previewやtelescopeみたいなpreviewの出し方をする
  " - winWidthの部分が内部コードに依存してるのでアレ
  " (previewVerticalの時、絶対位置にwinWidthを足して出しているのでその分を引き去る)
  " よってpreviewVertical = trueじゃないと動かない
  let s:config['uiParams']['ff']['previewCol'] = winCol + (winWidth / 2) - winWidth
  let s:config['uiParams']['ff']['previewWidth'] = winWidth / 2
  let s:config['uiParams']['ff']['previewRow'] = winRow
  let s:config['uiParams']['ff']['previewHeight'] = winHeight
endfunction

function! s:reset() abort
  call s:set_size()
  call ddu#custom#patch_global(s:config)
endfunction

call s:reset()
autocmd VimResized * call s:reset()

autocmd ColorScheme * hi DduFloat guibg=#e0e0ff guifg=#6060ff
autocmd ColorScheme * hi DduBorder guibg=#f0f0ff guifg=#6060ff
autocmd ColorScheme * hi DduMatch ctermfg=205 ctermbg=225 guifg=#ff60c0 guibg=#ffd0ff cterm=NONE gui=NONE
autocmd ColorScheme * hi DduCursorLine ctermfg=205 ctermbg=225 guifg=#ff6060 guibg=#ffe8e8 cterm=NONE gui=NONE

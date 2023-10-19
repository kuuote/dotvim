let s:loaded_ft = {}
let s:dir = expand('$VIMDIR/snippets/')

function s:load()
  let ft = &filetype
  if empty(ft) || has_key(s:loaded_ft, ft)
    return
  endif
  let s:loaded_ft[ft] = v:true
  let toml = s:dir .. ft .. '.toml'
  if filereadable(toml)
    call denippet#load(toml)
  endif
endfunction

autocmd InsertEnter * call s:load()
" 挿入モード内で呼ばれる想定なので初回は手で呼ぶ
call s:load()

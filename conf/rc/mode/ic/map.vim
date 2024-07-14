" CAPS LOCK
"" skkeletonは便利ですね本当に
function s:caps()
  for mode in ['i', 'c']
    call skkeleton#internal#map#save(mode)
    for key in 'abcdefghijklmnopqrstuvwxyz'->split('\zs')
      execute printf('%snoremap <buffer> %s %s', mode, key, key->toupper())
    endfor
  endfor
  augroup vimrc_caps
    autocmd! * <buffer>
    autocmd InsertLeave <buffer> ++once call skkeleton#internal#map#restore()
  augroup END
endfunction

inoremap C <Cmd>call <SID>caps()<CR>

" Cmdlineをキャンセルした際に履歴を残さない
cnoremap <Esc> <C-u><C-c>

" code input advanced in insert mode
"" thanks monaqa and tsuyoshicho
inoremap <C-v>u <C-r>=nr2char(0x)<Left>

" kigou utiyasuku suru
noremap! ,q <Bar>
noremap! ,a \
noremap! ,z _

noremap! ,s :

noremap! ,e +
noremap! ,d =
noremap! ,c *

noremap! ,f #

" notation helper
function s:notation()
  let ve = &l:virtualedit
  try
    let &l:virtualedit = 'onemore'
    let result = input('')
    if !empty(result)
      if result[0] ==# '.'
        let result = toupper(result[1:])
      elseif result[0] ==# '/'
        let result = result[1:]
      else
        let result = toupper(result[0]) .. result[1:]
      endif
      let result = '<' .. result .. '>'
      call feedkeys(result, 'ni')
    endif
  finally
    let &l:virtualedit = ve
  endtry
endfunction
noremap! ,, <Cmd>call <SID>notation()<CR>

" pum.vim
"" X<mappings-pum_vim>
function s:pum_select_by(reverse, callback) abort
  let info = pum#complete_info()
  if info.selected == -1
    " 選択されていない場合は端から
    if a:reverse
      let index = len(info.items) - 1
    else
      let index = 0
    endif
  else
    let index = info.selected
  endif
  let current = info.items[index]
  " 現在位置から端まで舐める
  for i in a:reverse ? range(index - 1, 0, -1) : range(index + 1, len(info.items) - 1)
    " マッチしたらそこまでカーソルを動かし
    if a:callback(current, info.items[i])
      call pum#map#select_relative(i - info.selected)
      return
    endif
  endfor
  " そうじゃなければ選択を解除
  call pum#map#select_relative(-index - 1)
endfunction

function s:pum_candidate_compare(a, b) abort
  let a = a:a
  let b = a:b
  if a.__sourceName !=# b.__sourceName
    return v:true
  endif
  if a.__sourceName ==# 'skkeleton_okuri'
    return strchars(a.data.skkeleton_okuri.okuri) != strchars(b.data.skkeleton_okuri.okuri)
  endif
  return v:false
endfunction

function s:pum_mode() abort
  if !pum#visible()
    return
  endif
  call pum#map#select_relative(+1)
  let cont = v:true
  while cont
    let cont = v:false
    redraw
    let c = getcharstr()
    if c ==# "\<Tab>"
      call pum#map#select_relative(+1)
      let cont = v:true
    elseif c ==# "\<S-tab>"
      call pum#map#select_relative(-1)
      let cont = v:true
    elseif c ==# 'E'
      call pum#map#cancel()
    elseif c ==# 'N'
      call s:pum_select_by(v:false, function('s:pum_candidate_compare'))
      let cont = v:true
    elseif c ==# 'P'
      call s:pum_select_by(v:true, function('s:pum_candidate_compare'))
      let cont = v:true
    elseif c ==# "\<CR>"
      " do egg like
      call pum#map#confirm()
    else
      call pum#map#confirm()
      call feedkeys(c)
    endif
  endwhile
endfunction

noremap! <Tab> <Cmd>call <SID>pum_mode()<CR>
noremap! <C-n> <Cmd>call <SID>pum_select_by(v:false, function('<SID>pum_candidate_compare'))<CR>
noremap! <C-p> <Cmd>call <SID>pum_select_by(v:true, function('<SID>pum_candidate_compare'))<CR>

" single quoteをprefixにしてしまう
"" 括弧補完みたいなことをする
inoremap 'w <Cmd>call vsnip#anonymous("'$1'$0")<CR>
inoremap 't <Cmd>call vsnip#anonymous("'''\n$1\n'''$0")<CR>
inoremap "" <Cmd>call vsnip#anonymous('"$1"$0')<CR>

inoremap 'g <Cmd>call vsnip#anonymous('<$1>$0')<CR>
inoremap 'f <Cmd>call vsnip#anonymous('($1)$0')<CR>
inoremap 'd <Cmd>call vsnip#anonymous('[$1]$0')<CR>
inoremap 's <Cmd>call vsnip#anonymous('{$1}$0')<CR>
"" endwise like
inoremap 'e <Cmd>call vsnip#anonymous("\n\t$0\n")<CR>
inoremap '<Space> <Cmd>call vsnip#anonymous(' $0 ')<CR>
"" 一番上
inoremap 'z <Cmd>normal! zt<C-y><C-y><C-y><CR>
inoremap 'Z <Cmd>normal! zt<CR>
"" JISキーボード用
map! : '
"" スニペットジャンプ
function s:snipjump()
  if vsnip#jumpable(1)
    call vimrc#keycode#feedkeys('<Plug>(vsnip-jump-next)')
  elseif denops#plugin#is_loaded('denippet') && denippet#jumpable(1)
    call denippet#jump(1)
  endif
endfunction
inoremap F <Cmd>call <SID>snipjump()<CR>

"" sticky ;
noremap! <expr> ; toupper(getcharstr()[0])
noremap! ;<Tab> :
noremap! ;<Tab><Tab> ::


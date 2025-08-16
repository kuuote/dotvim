" CAPS LOCK
"" skkeletonは便利ですね本当に
function s:caps()
  for mode in ['i', 'c']
    call skkeleton#internal#map#save(mode)
    for key in 'abcdefghijklmnopqrstuvwxyz'->split('\zs')
      execute printf('%snoremap <buffer> <nowait> %s %s', mode, key, key->toupper())
    endfor
  endfor
  augroup vimrc_caps
    autocmd!
    autocmd ModeChanged *:n* ++once call skkeleton#internal#map#restore()
  augroup END
endfunction

noremap! C <Cmd>call <SID>caps()<CR>

" Cmdlineをキャンセルした際に履歴を残さない
cnoremap <Esc> <C-u><C-c>

" code input advanced in insert mode
"" thanks monaqa and tsuyoshicho
inoremap <C-v>u <C-r>=nr2char(0x)<Left>

" from https://github.com/kat0h/dotfiles/blob/7c371cd16f39e66f0960d3c847085ff64d19881d/dot_vim/keymap.vim#L51-L54
""Undoポイントを貼り付ける
inoremap <silent> <C-w> <C-g>u<C-w>
inoremap <silent> <C-u> <C-g>u<C-u>

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

function s:pum_mode(key) abort
  if !pum#visible()
    return
  endif
  call feedkeys(a:key, 'it')
  let cont = v:true
  while cont
    let cont = v:false
    redraw
    let c = getcharstr()
    if c ==# "\<C-n>"
      call pum#map#select_relative(+1)
      let cont = v:true
    elseif c ==# "\<C-p>"
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
    elseif c ==# "\<C-y>"
      " keyword単位でreplaceすると便利らしいので仕込んでみた
      call search('\%#\k*\zs')
      call pum#map#confirm()
    elseif c ==# "\<CR>"
      " do egg like
      call pum#map#confirm()
    else
      " pum.vimのconfirm->吸った文字->残りの入力の順番で並ぶ必要がある
      " pum.vimはconfirmをするとi付きでfeedkeysをするのでこの順番で処理をすると上手く行く
      call feedkeys(c, 'i')
      call pum#map#confirm()
    endif
  endwhile
endfunction

noremap! N <Cmd>call <SID>pum_mode('N')<CR>
noremap! P <Cmd>call <SID>pum_mode('P')<CR>
noremap! <C-n> <Cmd>call <SID>pum_mode('<C-n>')<CR>
noremap! <C-p> <Cmd>call <SID>pum_mode('<C-p>')<CR>

" single quoteをprefixにしてしまう
"" 一番上
inoremap 'z <Cmd>eval winsaveview()->extend({'topline': line('.') - 5})->winrestview()<CR>
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

" 単語ジャンプ by kawarimidoll
inoremap <expr> W getline('.')->len() == col('.') ? "\<right>" : "\<c-o>e\<right>"

" 無変換と変換
"" xremapかけてる前提の配置
noremap! <Left> <Plug>(muhenkan)
noremap! <Right> <Plug>(henkan)
silent! noremap! <unique> <Plug>(muhenkan) <Nop>
silent! noremap! <unique> <Plug>(henkan) <Nop>

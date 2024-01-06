" CAPS LOCK
"" skkeletonは便利ですね本当に
function s:caps()
  for mode in ['i', 'c']
    for key in 'abcdefghijklmnopqrstuvwxyz'->split('\zs')
      call skkeleton#save_map(mode, key)
      execute printf('%snoremap <buffer> %s %s', mode, key, key->toupper())
    endfor
  endfor
  augroup vimrc_caps
    autocmd InsertLeave <buffer> ++once call skkeleton#unmap()
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
noremap! <Tab> <Cmd>call pum#map#insert_relative(1)<CR>
noremap! <C-n> <Cmd>call pum#map#select_relative(+1)<CR>
noremap! <C-p> <Cmd>call pum#map#select_relative(-1)<CR>
noremap! <C-y> <Cmd>call pum#map#confirm()<CR>
noremap! <C-e> <Cmd>call pum#map#cancel()<CR>
noremap! N <Cmd>call pum#map#select_relative(+1)<CR>
noremap! P <Cmd>call pum#map#select_relative(-1)<CR>
noremap! Y <Cmd>call pum#map#confirm()<CR>
noremap! E <Cmd>call pum#map#cancel()<CR>

"" sticky ;
noremap! <expr> ; toupper(getcharstr()[0])
noremap! ;<Tab> :

" single quoteをprefixにしてしまう
noremap! 'w ''
noremap! 't '''
inoremap '<Space> <Plug>(denippet-jump-next)
"" 括弧補完みたいなことをする
inoremap "" <Cmd>call denippet#anonymous('"$1"$0')<CR>
inoremap '' <Cmd>call denippet#anonymous("'$1'$0")<CR>
inoremap 'g <Cmd>call denippet#anonymous('<$1>$0')<CR>
inoremap 'f <Cmd>call denippet#anonymous('($1)$0')<CR>
inoremap 'd <Cmd>call denippet#anonymous('[$1]$0')<CR>
inoremap 's <Cmd>call denippet#anonymous('{$1}$0')<CR>
"" endwise like
inoremap 'e <Cmd>call denippet#anonymous("\n\t$0\n")<CR>
"" JISキーボード用
map! : '


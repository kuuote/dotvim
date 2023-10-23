" Cmdlineをキャンセルした際に履歴を残さない
cnoremap <Esc> <C-u><C-c>

" code input advanced in insert mode
"" thanks monaqa and tsuyoshicho
inoremap <C-v>u <C-r>=nr2char(0x)<Left>

" kigou utiyasuku suru
noremap! ,q <Bar>
noremap! ,a \
noremap! ,z _

noremap! ,e +
noremap! ,d =
noremap! ,c *

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

" sticky ;
for s:c in split('abcdefghijklmnopqrstuvwxyz', '\zs')
  execute printf('noremap! ;%s %s', s:c, toupper(s:c))
endfor
noremap! ;<Tab> ;

" swap () []
noremap! [ (
noremap! ] )
noremap! ( [
noremap! ) ]


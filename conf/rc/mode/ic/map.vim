" swap () []
noremap! [ (
noremap! ] )
noremap! ( [
noremap! ) ]

" kigou utiyasuku suru
noremap! ,q <Bar>
noremap! ,a \
noremap! ,z _

noremap! ,e +
noremap! ,d =
noremap! ,c *

" notation helper
function s:notation()
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
endfunction
noremap! ,, <Cmd>call <SID>notation()<CR>

" pum.vim
" X<mappings-pum_vim>
noremap! <Tab> <Cmd>call pum#map#insert_relative(1)<CR>
noremap! <C-n> <Cmd>call pum#map#select_relative(+1)<CR>
noremap! <C-p> <Cmd>call pum#map#select_relative(-1)<CR>
noremap! <C-y> <Cmd>call pum#map#confirm()<CR>
noremap! <C-e> <Cmd>call pum#map#cancel()<CR>


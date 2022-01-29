let s:ui = {}

let s:ui[''] = {
\   'edit': 'edit ' .. expand('<sfile>:p'),
\   'help': 'call selector#source#help#run()',
\   'plugin/dein.vim': 'UI plugin/dein.vim',
\   'copypath': 'call setreg(v:register, expand("%:p"), "V")',
\ }

let s:ui['plugin/dein.vim'] = {
\   'install': "*call dein#install()\<Left>",
\   'check_update': 'call dein#check_update()',
\ }

function s:add_sub(name, funcname) abort
  let s:ui[''][a:name] = 'UI ' .. a:name
  let s:ui[a:name] = a:funcname
endfunction

call s:add_sub('plugin/fzf-preview.vim', 'vimrc#ui#plugin#fzf_preview#menu()')
if has('nvim')
  call s:add_sub('plugin/telescope', 'vimrc#ui#plugin#telescope#menu()')
endif

function vimrc#ui#menu(...) abort
  let name = get(a:000, 0, '')
  let ui = s:ui[name]
  if type(ui) == v:t_string
    let ui = eval(ui)
  endif
  let result = ui[selector#run(sort(keys(ui)), 'fzf')]
  if type(result) != v:t_string
    throw "Illegal result: " .. result
  endif
  if result[0] ==# '*'
    call feedkeys(':' .. result[1:], 'n')
  else
    call histadd(':', result)
    execute result
  endif
endfunction

command! -nargs=? UI call vimrc#ui#menu('<args>')

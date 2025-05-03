let g:lexima_no_default_rules = 1

call lexima#clear_rules()

imap <C-h> <BS>
cmap <C-h> <BS>

for s:rule in lexima#endwise_rule#make()
  call lexima#add_rule(s:rule)
endfor

for s:rule in g:lexima#newline_rules
  call lexima#add_rule(s:rule)
endfor
" NixやTOMLの複数行文字列にnewline rule適用する
call lexima#add_rule({'char': '<CR>', 'at': "''\\%#''", 'input_after': '<CR>'})

function s:esc(str)
  return escape(a:str, '[')
endfunction

function s:add_pair_rule(char, input, input_after)
  let input = s:esc(a:input)
  let input_after = s:esc(a:input_after)
  call lexima#add_rule({'char': a:char, 'input': a:input, 'input_after': a:input_after})
  call lexima#add_rule({'char': '<BS>', 'at': input .. '\%#' .. input_after, 'delete': 1})
endfunction

call s:add_pair_rule("'w", "'", "'")
call s:add_pair_rule("'q", '"', '"')
call s:add_pair_rule("'g", '<', '>')
call s:add_pair_rule("'f", '(', ')')
call s:add_pair_rule("'d", '[', ']')
call s:add_pair_rule("'s", '{', '}')
call s:add_pair_rule("'b", '`', '`')

" https://cohama.hateblo.jp/entry/2022/01/12/190000
function s:add_leave_rule(seq)
  call lexima#add_rule({'char': '<Tab>', 'at': '\%#\s*' .. a:seq, 'leave': a:seq})
  call lexima#add_rule({'char': '<Tab>', 'at': '\%#$\n\s*' .. a:seq, 'leave': a:seq})
endfunction

call s:add_leave_rule('>')
call s:add_leave_rule(')')
call s:add_leave_rule(']')
call s:add_leave_rule('}')
call s:add_leave_rule("'")
call s:add_leave_rule("''")
call s:add_leave_rule("'''")
call s:add_leave_rule('"')

source $VIMCONF/conf/plug/vim/lexima/nix.vim
source $VIMCONF/conf/plug/vim/lexima/vim.vim

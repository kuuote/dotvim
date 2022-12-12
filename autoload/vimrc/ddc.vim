function vimrc#ddc#reset()
  let g:vimrc#ddc#gather = {...->[{'word': 'unko'}]}
  " 無効な値を返すとデフォルト動作にフォールバックされるが
  " v:nullなどはnumber扱いされるので返してはいけない
  let g:vimrc#ddc#get_complete_position = {...->'unchi'}
  let g:vimrc#ddc#on_complete_done = {...->'kuso'}
endfunction
call vimrc#ddc#reset()

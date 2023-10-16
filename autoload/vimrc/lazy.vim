function vimrc#lazy#on_map(keys, plugin)
  execute 'nunmap ' .. a:keys
  call dpp#source(a:plugin)
  call feedkeys(a:keys, 'it')
endfunction

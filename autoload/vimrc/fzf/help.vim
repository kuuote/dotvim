function! s:help_tags() abort
  let tags = []
  for path in split(&runtimepath, ',')
    let filepath = path .. '/doc/tags'
    if !filereadable(filepath)
      continue
    endif
    let t = readfile(filepath)
    let t = map(t, 'split(v:val, "\<Tab>")[0]')
    call extend(tags, t)
  endfor
  return sort(tags)
endfunction

function! vimrc#fzf#help#run() abort
  call vimrc#fzf#run(s:help_tags(), 'help', '--reverse')
endfunction

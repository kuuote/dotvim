function! s:help_tags() abort
  if exists('s:cache')
    return s:cache
  endif
  let tags = []
  for path in globpath(&runtimepath, 'doc/tags', 1, 1) + globpath(&runtimepath, 'doc/tags-??', 1, 1)
    let t = readfile(path)
    call map(t, 'split(v:val, "\<Tab>")[0]')
    call extend(tags, t)
  endfor
  let s:cache = sort(tags)
  return s:cache
endfunction

function! selector#source#help#run() abort
  let tag = selector#run(s:help_tags(), 'fzf')
  if !empty(tag)
    execute 'help' tag
  endif
endfunction

function s:link(from, to)
  let plug = dein#get(a:from)
  if !empty(plug)
    call system(printf('ln -s %s %s', plug.path, a:to))
  endif
endfunction

let s:dir = expand('$DOTVIM/deno')
call delete(s:dir, 'rf')
call mkdir(s:dir, 'p')

" X<denops-depends-link>
call s:link('ddc.vim', s:dir .. '/ddc.vim')
call s:link('ddu-kind-file', s:dir .. '/ddu-kind-file')
call s:link('ddu-source-git_branch', s:dir .. '/ddu-source-git_branch')
call s:link('ddu-source-git_status', s:dir .. '/ddu-source-git_status')
call s:link('ddu-source-tags', s:dir .. '/ddu-source-tags')
call s:link('ddu-ui-ff', s:dir .. '/ddu-ui-ff')
call s:link('ddu.vim', s:dir .. '/ddu.vim')
call s:link('deno-denops-std', s:dir .. '/denops_std')
call s:link('deno-unknownutil', s:dir .. '/unknownutil')
call s:link('deno_std', s:dir .. '/deno_std')
call s:link('lspoints', s:dir .. '/lspoints')

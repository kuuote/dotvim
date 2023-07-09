function s:link(from, to)
  call system(printf('ln -s %s %s', a:from, a:to))
endfunction

let s:dir = expand('$DOTVIM/deno')
call delete(s:dir, 'rf')
call mkdir(s:dir, 'p')

call s:link(dein#get('ddc.vim').path, s:dir .. '/ddc.vim')
call s:link(dein#get('ddu-kind-file').path, s:dir .. '/ddu-kind-file')
call s:link(dein#get('ddu-source-git_status').path, s:dir .. '/ddu-source-git_status')
call s:link(dein#get('ddu-ui-ff').path, s:dir .. '/ddu-ui-ff')
call s:link(dein#get('ddu.vim').path, s:dir .. '/ddu.vim')
call s:link(dein#get('deno-denops-std').path, s:dir .. '/denops_std')
call s:link(dein#get('deno-unknownutil').path, s:dir .. '/unknownutil')
call s:link(dein#get('deno_std').path, s:dir .. '/deno_std')

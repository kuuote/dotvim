let g:vimrc#build#target = get(g:, 'vimrc#build#target', {})

function! vimrc#build#add(plugin) abort
  let g:vimrc#build#target[a:plugin.name] = a:plugin.path
endfunction

function! vimrc#build#output() abort
  let plugins = sort(items(g:vimrc#build#target))
  let gen = [['#!/bin/bash -u']]
  for [plug, path] in plugins
    let script_path = printf('%s/.vim/build/%s.sh', $HOME, plug)
    let script_hash = sha256(join(readfile(script_path), "\n"))
    let repo_hash = trim(system(printf('git -C %s rev-parse origin/HEAD', path)))

    let hash_path = printf('%s/.vimrc_hash', path)
    let file = []
    silent! let file = readfile(hash_path)
    if get(file, 0, '') ==# script_hash && get(file, 1, '') ==# repo_hash
      continue
    endif
    
    let builder = [
          \ '(',
          \ 'set -ex',
          \ printf('cd %s', path),
          \ 'git reset origin/HEAD',
          \ 'git clean -ffdx',
          \ 'git restore .',
          \ script_path,
          \ printf(') && echo -e "%s\n%s" > %s', script_hash, repo_hash, hash_path),
          \ ]
    call add(gen, builder)
  endfor
  " invoke dein recache
  call add(gen, 'touch ~/.vim/vimrc')
  let builder_path = $HOME .. '/.vim/build.sh'
  call writefile(flatten(gen), builder_path)
  call setfperm(builder_path, 'rwxrwxrwx')

  if confirm('write build script. run on vim?', "&Yes\n&No", 2) == 1
    execute 'terminal' builder_path
  endif
endfunction

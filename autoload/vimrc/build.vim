" ビルドログを眺めてニヤニヤするためのツール

let s:targets = readfile(expand('~/.vim/build/build.json'))->join('')->json_decode()

function! vimrc#build#output() abort
  let plugins = sort(items(s:targets), {a, b -> a[0] < b[0]})
  let gen = [['#!/bin/bash -u']]
  for [name, def] in plugins
    let plug = dein#get(name)
    if empty(plug)
      continue
    endif
    let hashes = []
    let script_path = expand(def.script)
    let scripts = extend([script_path], get(def, 'aux', [])->map('expand(v:val)'))
    let hashes = scripts->map('readfile(v:val)->join("\n")->sha256()')

    call add(hashes, trim(system(printf('git -C %s rev-parse origin/HEAD', plug.path))))

    let hash = sha256(join(hashes, '\n'))

    let hash_path = printf('%s/.vimrc_hash', plug.path)
    try
      let file = readfile(hash_path)
    catch
      let file = []
    endtry
    if get(file, 0, '') ==# hash
      continue
    endif
    
    let builder = [
          \ '(',
          \ 'set -ex',
          \ printf('cd %s', plug.path),
          \ 'git reset origin/HEAD',
          \ 'git clean -ffdx',
          \ 'git restore .',
          \ script_path,
          \ printf(') && echo -e "%s" > %s', hash, hash_path),
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
    normal! G
  endif
endfunction

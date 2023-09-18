if &runtimepath =~# 'dein.vim'
  echo '現在のdein.vimの状態を使用します'
else
  let $DOTVIM = expand('<sfile>:p:h:h:h')
  set runtimepath+=/data/vim/repos/github.com/Shougo/dein.vim
  call dein#begin('/data/vim')
  for toml in glob('~/.vim/conf/**/*.toml', 1, 1)
    if toml =~# 'disable'
      continue
    endif
    let data = dein#toml#parse_file(toml)
    for plugin in data.plugins
      silent! unlet plugin.hook_add
      silent! unlet plugin.lua_add
      call dein#add(plugin.repo, plugin)
    endfor
  endfor
endif

let out = []
for d in values(dein#get())
  if d.repo[0] == '/'
    continue
  endif
  let def = {}
  let def.repo = d.repo
  let def.label = d.name
  if stridx(def.repo, ':') == -1
    let def.repo = 'https://github.com/' .. def.repo
  endif
  let def.path = d.path
  if has_key(d, 'rev')
    let def.rev = d.rev
  endif
  call add(out, def)
endfor

call sort(out, { a, b -> a.repo < b.repo })

call writefile([json_encode(out)], expand('$DOTVIM/script/gitupdate/out.json'))
call writefile(dein#check_clean(), '/tmp/deinclean')

set runtimepath^=/data/vim/repos/github.com/Shougo/dpp.vim

let g:vimrc#dpp_base = '/tmp/dpp'
if dpp#min#load_state(g:vimrc#dpp_base)
  autocmd vimrc User Dpp:makeStatePost quit!
  source $VIMDIR/conf/makestate.vim
  finish
endif

" adhoc hook
let s:hook_file = '/tmp/inline.vim/' .. ('dpp_hook_' .. v:progpath .. '.vim')->substitute('/', '_', 'g')
if getftype(s:hook_file) ==# 'file'
  execute 'source' s:hook_file
  finish
else
  let s:sokutei = v:false
  let s:inline = s:sokutei ? ['let s:jikan = reltime()'] : []
  for [s:key, s:plugin] in dpp#_plugins->items()
    if s:plugin.sourced && has_key(s:plugin, 'hook_source')
      call add(s:inline, printf('let s:plugin = dpp#get(%s)', string(s:key)))
      call add(s:inline, 'unlet s:plugin.hook_source')
      call add(s:inline, s:plugin.hook_source->trim())
      if s:sokutei
        call add(s:inline, printf('echomsg "hook_source %s " .. reltimestr(reltime(s:jikan))', s:plugin.name))
      endif
    endif
  endfor
  call mkdir('/tmp/inline.vim', 'p')
  call writefile(s:inline->join("\n")->split("\n"), s:hook_file)
  execute 'source' s:hook_file
endif

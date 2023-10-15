call ddc#custom#load_config(expand('$VIMDIR/conf/plug/ddc/main.ts'))
call ddc#custom#load_config(expand('$VIMDIR/conf/plug/ddc/manual.ts'))
call ddc#enable()
autocmd CmdlineEnter : call ddc#enable_cmdline_completion()
autocmd User DenopsPluginPost:ddc call ddc#enable_cmdline_completion()
" 現状呼ばれてないっぽいんで@もついでに呼んでおく
autocmd CmdlineEnter :,@ call ddc#on_event('CmdlineEnter')
" CmdlineEnterをトリガーにするので再度呼んでおく
if mode() == 'c' && getcmdtype() =~# '[:@]'
  call ddc#on_event('CmdlineEnter')
endif

" deflicker echo area
set noshowmode

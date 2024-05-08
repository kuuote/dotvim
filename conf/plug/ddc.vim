call ddc#custom#load_config(expand('$VIMDIR/conf/plug/ddc/main.ts'))
call ddc#custom#load_config(expand('$VIMDIR/conf/plug/ddc/manual.ts'))
call ddc#enable()
autocmd vimrc CmdlineEnter : call ddc#enable_cmdline_completion()
autocmd vimrc User DenopsPluginPost:ddc call ddc#enable_cmdline_completion()
" 現状呼ばれてないっぽいんで@もついでに呼んでおく
autocmd vimrc CmdlineEnter :,@ call ddc#on_event('CmdlineEnter')
" CmdlineEnterをトリガーにするので再度呼んでおく
if mode() == 'c' && getcmdtype() =~# '[:@]'
  call ddc#on_event('CmdlineEnter')
endif

" deflicker echo area
set noshowmode

" acwriteセットされてるファイルで補完効かなくて困ることは無いと思う
autocmd vimrc OptionSet buftype if &buftype ==# 'acwrite' | call ddc#custom#patch_buffer('specialBufferCompletion', v:true) | endif
if &buftype ==# 'acwrite' | call ddc#custom#patch_buffer('specialBufferCompletion', v:true) | endif

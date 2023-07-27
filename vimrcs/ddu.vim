set rtp+=/data/vim/repos/github.com/Shougo/ddu-filter-matcher_substring
set rtp+=/data/vim/repos/github.com/Shougo/ddu-source-file
set rtp+=/data/vim/repos/github.com/Shougo/ddu-ui-ff
set rtp+=/data/vim/repos/github.com/Shougo/ddu.vim
set rtp+=/data/vim/repos/github.com/vim-denops/denops.vim

call ddu#custom#patch_global('sourceOptions', #{file: #{matchers: ['matcher_substring']}})
call ddu#custom#patch_global('sources', [#{name: 'file'}])
call ddu#custom#patch_global('ui', 'ff')
nnoremap <Space> <Cmd>call ddu#start()<CR>

" => ~/.vim/denops/vimrc/main.ts
nnoremap <buffer> mf <Cmd>call denops#request('vimrc', 'formatJSON', [])<CR>
command! -buffer JY call denops#request('vimrc', 'jsonYAML', [])
command! -buffer YJ call denops#request('vimrc', 'yamlJSON', [])

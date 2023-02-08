" => ~/.vim/denops/vimrc/main.ts
nnoremap <buffer> mf <Cmd>call denops#request('vimrc', 'formatJSON', [])<CR>
command! -buffer -range=% JY call denops#request('jsonyaml', 'jsonYAML', [<line1>, <line2>])
command! -buffer -range=% YJ call denops#request('jsonyaml', 'yamlJSON', [<line1>, <line2>])

call minpac#add('https://github.com/nvim-treesitter/nvim-treesitter',{'type': 'opt'})


function! s:treesitter_config() abort
  packadd nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
}
EOF
endfunction

" filetypeコマンドよりも後に設定しないとだめ(使えはするけど普通のシンタックスも読み込まれてしまう)
au VimEnter * call s:treesitter_config()

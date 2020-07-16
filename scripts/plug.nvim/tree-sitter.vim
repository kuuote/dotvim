call minpac#add('nvim-treesitter/nvim-treesitter', {'type': 'opt'})

function! s:load_treesitter() abort
  packadd nvim-treesitter
" lua <<EOF
" require'nvim-treesitter.configs'.setup {
"   highlight = {
"     enable = true,
"   },
" }
" EOF
  TSEnableAll highlight
endfunction

autocmd vimrc VimEnter * call s:load_treesitter()

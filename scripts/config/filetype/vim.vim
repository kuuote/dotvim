" 行継続のアレ
let g:vim_indent_cont = 0

function s:ft_init()
  "zc+任意のキーで<C-?>を入力
  inoremap <buffer> <expr> zc printf("<C-%s>", nr2char(getchar()))

  "一部分の設定はsonictemplateの方に移動してある
  inoremap <buffer> <expr> z# vimrc#autoloadname()
  " inoremap <buffer> z<CR> <lt>CR>
  " inoremap <buffer> z<Space> <lt>Space>
  " inoremap <buffer> zS <lt>SID>
  " inoremap <buffer> zb <lt>buffer>
  " inoremap <buffer> zl <lt>lt>
  " inoremap <buffer> zp <lt>Plug>
  " inoremap <buffer> zs <lt>silent>
  " inoremap <buffer> zt <lt>Tab>
endfunction

autocmd vimrc FileType vim call s:ft_init()

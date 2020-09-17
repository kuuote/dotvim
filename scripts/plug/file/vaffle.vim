call minpac#add('cocopon/vaffle.vim')

"shortcut to vaffle in current directory
nnoremap <Space>d :Vaffle %:p:h<Enter>
" let g:vaffle_show_hidden_files=1
let g:vaffle_auto_cd=0

function! s:customize_vaffle_mappings() abort
  " Customize key mappings here
  nmap <buffer> <Bslash> <Plug>(vaffle-open-root)
  nmap <buffer> K        <Plug>(vaffle-mkdir)
  nmap <buffer> N        <Plug>(vaffle-new-file)
  nor  <buffer> <silent> <Space>cd :silent :execute printf('lcd %s', fnameescape(vaffle#buffer#extract_path_from_bufname(@%)))<CR>:echo "change directory"<CR>
  nor  <buffer> <expr> y setreg(v:register, strpart(@%, 11) . "/" . expand("<cfile>"))
endfunction

augroup vimrc
  autocmd FileType vaffle call s:customize_vaffle_mappings()
  " autocmd FileType vaffle setlocal foldmethod=marker
augroup END

UsePlugin vim-lsp

" さすまつ https://mattn.kaoriya.net/software/vim/20191231213507.htm

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <Plug>(lsp-definition)
  inoremap <expr> <CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
endfunction

augroup vimrc
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 1

command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')

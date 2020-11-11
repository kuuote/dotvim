call minpac#add('mattn/vim-lsp-settings', {'type': 'opt'})
call minpac#add('prabirshrestha/async.vim', {'type': 'opt'})
call minpac#add('prabirshrestha/vim-lsp', {'type': 'opt'})

function! s:load_lsp() abort
  packadd vim-vsnip-integ
  packadd vim-lsp-settings
  packadd async.vim
  packadd vim-lsp
  if v:vim_did_enter
    " 本来はVimEnterで呼ばれてる
    call lsp#enable()
  endif
  if filereadable(expand("%:p"))
    edit
  else
    execute "doautocmd BufNewFile " .. fnamemodify(@%, ":p")
    execute "doautocmd FileType " .. &l:ft
  endif
endfunction

autocmd FileType go,python,rust ++once ++nested call s:load_lsp()

" see https://mattn.kaoriya.net/software/vim/20191231213507.htm
" とりあえずログ吐いておく
let g:lsp_log_verbose = v:true
" HDDアクセスが遅いのでメモリに吐く
let g:lsp_log_file = "/tmp/lsp.log"
if !v:vim_did_enter && !filewritable(g:lsp_log_file)
  unlet g:lsp_log_file
endif

let g:lsp_diagnostics_enabled = v:true
let g:lsp_diagnostics_echo_cursor = v:true

" noinsertやnoselectはふべん
" let g:asyncomplete_auto_completeopt = 0

function! s:on_lsp() abort
  setlocal omnifunc=lsp#complete
  " グローバルで切ったのでここで代わりに
  " setlocal completeopt=menuone,noinsert,noselect
  inoremap <expr> <CR> pumvisible() ? "\<c-y>\<CR>" : "\<CR>"
  noremap <buffer> gd :<C-u>tab LspDefinition<CR>
  nmap <buffer> K <Plug>(lsp-hover)
endfunction

autocmd vimrc User lsp_buffer_enabled call s:on_lsp()

" vim-lsp-settings
let g:lsp_settings = {
\ "bash-language-server": {"disabled": v:true},
\ "vim-language-server": {"disabled": v:true},
\}

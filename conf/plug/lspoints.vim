function s:initialize()
  call lspoints#load_extensions([
  \   'config',
  \   'format',
  \   'nvim_diagnostics',
  \ ])
"  \   'semantic_tokens',
endfunction
call s:initialize()

function s:on_attach()
  " L<toml-ddu_source_lsp>
  let b:ddu_source_lsp_clientName = 'lspoints'

  nnoremap <buffer> ma <Cmd>DduSelectorCall lsp_codeAction<CR>
  nnoremap <buffer> mf <Cmd>call denops#request('lspoints', 'executeCommand', ['format', 'execute', bufnr()])<CR>
  nnoremap <buffer> gd <Cmd>DduSelectorCall lsp_definition<CR>
endfunction
autocmd vimrc User LspointsAttach:* call s:on_attach()

function s:attach_denols() abort
  let name = bufname()
  if name =~# ':/' && name !~# '^\v(file|deno)'
    return
  endif
  call lspoints#attach('denols')
endfunction

autocmd vimrc FileType typescript,typescriptreact call s:attach_denols()

function s:initialize()
  call lspoints#load_extensions([
  \   'config',
  \   'format',
  \   'nvim_diagnostics',
  \   'semantic_tokens',
  \ ])
endfunction
autocmd User DenopsPluginPost:lspoints call s:initialize()

autocmd FileType lua call lspoints#attach('luals')
autocmd FileType typescript,typescriptreact call lspoints#attach('denols')

function s:on_attach()
  nnoremap <buffer> ma <Cmd>DduSelectorCall lsp_codeAction<CR>
  nnoremap <buffer> mf <Cmd>call denops#request('lspoints', 'executeCommand', ['format', 'execute', bufnr()])<CR>
endfunction
autocmd User LspointsAttach:* call s:on_attach()

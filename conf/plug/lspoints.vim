function s:initialize()
  call lspoints#load_extensions([
  \   'format',
  \   'nvim_diagnostics',
  \ ])
"  \   'semantic_tokens',
  call lspoints#settings#patch(#{
  \   tracePath: '/tmp/lspoints',
  \ })
endfunction
autocmd User DenopsPluginPost:lspoints call s:initialize()

function s:on_attach()
  nnoremap <buffer> ma <Cmd>DduSelectorCall lsp_codeAction<CR>
  nnoremap <buffer> mf <Cmd>call denops#request('lspoints', 'executeCommand', ['format', 'execute', bufnr()])<CR>
endfunction
autocmd User LspointsAttach:* call s:on_attach()

function s:attach_denols() abort
  call lspoints#attach('denols', #{
  \   cmd: ['deno', 'lsp'],
  \   initializationOptions: #{
  \     enable: v:true,
  \     unstable: v:true,
  \     suggest: #{
  \       autoImports: v:false,
  \     },
  \   },
  \ })
endfunction

autocmd FileType typescript,typescriptreact call s:attach_denols()

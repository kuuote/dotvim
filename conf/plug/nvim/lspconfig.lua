vim.api.nvim_create_autocmd('LspAttach', {
  group = 'vimrc',
  callback = function()
    local opts = {
      buffer = true,
    }
    vim.keymap.set('n', 'ma', '<Cmd>DduSelectorCall lsp_codeAction<CR>', opts)
    vim.keymap.set('n', 'mf', '<Cmd>lua vim.lsp.buf.format()<CR>', opts)
  end,
})

local lspconfig = require('lspconfig')

lspconfig.denols.setup {
  autostart = false,
  settings = {
    deno = {
      suggest = {
        imports = {
          hosts = {
            ['https://deno.land'] = false,
          },
        },
      },
      unstable = true,
    },
  },
}

lspconfig.rust_analyzer.setup {
  autostart = false,
}

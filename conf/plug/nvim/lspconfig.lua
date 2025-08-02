vim.api.nvim_create_autocmd('LspAttach', {
  group = 'vimrc',
  callback = function(ev)
    local opts = {
      buffer = true,
    }
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    vim.keymap.set('n', 'ma', '<Cmd>DduSelectorCall lsp_codeAction<CR>', opts)
    if client.server_capabilities.documentFormattingProvider then
      vim.keymap.set('n', 'mf', '<Cmd>lua vim.lsp.buf.format()<CR>', opts)
    end
  end,
})

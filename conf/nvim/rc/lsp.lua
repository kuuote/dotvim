vim.api.nvim_create_autocmd('LspAttach', {
  once = true,
  callback = function()
    -- iikanji hover handler
    vim.lsp.handlers['textDocument/hover'] = function(_, results, ctx, config)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      vim.lsp.handlers.hover(
        _,
        results,
        ctx,
        vim.tbl_deep_extend('force', config or {}, {
          border = 'single',
          title = client.name,
        })
      )
    end
  end,
})

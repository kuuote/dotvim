local cmp = require('cmp')

-- Global setup.
cmp.setup {
  enabled = function()
    if vim.g.cmp then
      return true
    end
    return false
  end,
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
      },
  window = {
    completion = cmp.config.window.bordered {
      border = 'single',
    },
    documentation = cmp.config.window.bordered {
      border = 'single',
    },
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
  },
  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
    { name = 'skkeleton' },
  },
}

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})

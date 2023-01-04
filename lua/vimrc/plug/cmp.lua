local cmp = require('cmp')

local M = {}

M.change_sources = setmetatable({
  default = function()
    cmp.setup {
      sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
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
        { name = 'skkeleton' },
      }, {
        {
          name = 'cmdline',
          max_item_count = 20,
        },
      }),
    })
  end,
  skkeleton = function()
    cmp.setup {
      sources = cmp.config.sources {
        { name = 'skkeleton' },
      },
    }
    cmp.setup.cmdline(':', {
      sources = cmp.config.sources {
        { name = 'skkeleton' },
      },
    })
  end,
}, {
  __call = function(self, name)
    return self[name]()
  end,
})

return M

local vimx = require('artemis')
vimx.create_autocmd('User', {
  pattern = 'operandi#open#command',
  callback = function()
    vimx.fn.ddc.custom.set_buffer {
      sources = { 'file', 'cmdline' },
      sourceOptions = {
        file = {
          matchers = {},
          sorters = {
            'sorter_file',
            'sorter_alignment',
          },
          converters = {},
        },
      },
      specialBufferCompletion = true,
    }
    vimx.keymap.set('i', '<C-p>', function()
      local pos = vim.fn.col('.')
      local left = vim.fn.getline('.'):sub(pos - 1, pos)
      local k
      if left == '/' then
        k = vim.fn.expand('#:p:t')
      else
        k = vim.fn.expand('#:p:h') .. '/'
      end
      vim.fn.feedkeys(k, 'n')
    end, {
      buffer = true,
    })
    -- vimx.keymap.set('i', '<C-p>', function()
    --   -- dirpath
    --   local path = vim.fn.expand('#:p:h')
    --   path = vim.fn.substitute(path, '/*$', '/', '')
    --   vim.fn.feedkeys(path, 'n')
    -- end, {
    --   buffer = true,
    -- })
  end,
})

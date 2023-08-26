local vimx = require('artemis')
vimx.create_autocmd('User', {
  pattern = 'operandi#open#command',
  callback = function()
    if vim.fn['dein#is_available']('ddc.vim') == 1 then
      vimx.fn.ddc.custom.set_buffer {
        sources = { 'file', 'cmdline' },
        sourceOptions = {
          file = {
            matchers = {},
            sorters = {
              'sorter_file',
              'sorter_ngram',
            },
            converters = {},
          },
        },
        specialBufferCompletion = true,
      }
    end
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
    vim.fn.setline(1, ':')
  end,
})

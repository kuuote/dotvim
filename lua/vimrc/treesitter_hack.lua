local treesitter_disallow_filetype = {
}

local ts = require('vim.treesitter')

local start = ts.start
ts.start = function(...)
  local filetype = vim.bo[vim.fn.bufnr()].filetype
  if not treesitter_disallow_filetype[filetype] then
    vim.call('dpp#source', 'nvim-treesitter')
    return start(...)
  end
end

local treesitter_allow_filetype = {
  diff = true,
  lua = true,
}

local ts = require('vim.treesitter')

local start = ts.start
ts.start = function(...)
  local filetype = vim.bo[vim.fn.bufnr()].filetype
  if treesitter_allow_filetype[filetype] then
    vim.call('dpp#source', 'nvim-treesitter')
    return start(...)
  end
end

local treesitter_allow_filetype = {
  diff = true,
}

local ts = require('vim.treesitter')

local start = ts.start
ts.start = function(bufnr, lang)
  local filetype = vim.bo[bufnr or vim.fn.bufnr()].filetype
  if treesitter_allow_filetype[filetype] then
    return start(self, bufnr, lang)
  end
end

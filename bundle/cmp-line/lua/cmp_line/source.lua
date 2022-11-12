local source = {}

source.new = function()
  local self = setmetatable({}, { __index = source })
  self.buffers = {}
  return self
end

source.complete = function(self, params, callback)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local items = vim.tbl_map(function(line)
    return {
      label = line,
    }
  end, lines)
  callback({
    items = items,
    isIncomplete = false,
  }, 100)
end


return source

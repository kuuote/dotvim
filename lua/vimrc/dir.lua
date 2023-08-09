local M = {}

function M.get_special_buffer_path()
  local path = vim.fn.bufname('%')
  -- gin.vim
  local match = path:match('gin%a+://([^;]+)')
  if match ~= nil then
    return match
  end
end

return M

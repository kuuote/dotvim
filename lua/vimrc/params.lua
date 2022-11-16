local default = vim.fn.expand('~') .. '/.vim/params'
local user = '/tmp/vim-params'

local M = {}

function M.get(name)
  local default_path = default .. '/' .. name .. '.lua'
  local user_path = user .. '/' .. name .. '.lua'
  local ok, result = pcall(function()
    return loadfile(user_path)()
  end)
  if ok then
    return result
  end
  return loadfile(default_path)()
end

function M.edit(name)
  if name == nil then
    local files = vim.fn.readdir(default, function(name)
      return name:match('lua$') ~= nil
    end)
    vim.ui.select(
      vim.tbl_map(function(name)
        return name:sub(1, #name - 4)
      end, files),
      {},
      function(choice)
        if choice ~= nil then
          M.edit(choice)
        end
      end
    )
    return
  end
  local default_path = default .. '/' .. name .. '.lua'
  local user_path = user .. '/' .. name .. '.lua'
  if vim.fn.getftype(user_path) ~= 'file' then
    vim.fn.mkdir(user, 'p')
    local lines = vim.fn.readfile(default_path)
    vim.fn.writefile(lines, user_path)
  end
  vim.cmd('-tabedit ' .. user_path)
end

return M

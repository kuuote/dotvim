local M = {}

---@param tbl table
---@return table
function M.reverse(tbl)
  local mid = math.floor(#tbl / 2)
  for i = 1, mid, 1 do
    tbl[i], tbl[#tbl - i + 1] = tbl[#tbl - i + 1], tbl[i]
  end
  return tbl
end

---@param path string
---@return string[]
function M.load_file(path)
  local ok, result = pcall(function()
    local found = {}
    local lines = {}
    for line in io.lines(path) do
      if line:match('%a') and found[line] == nil then
        found[line] = true
        lines[#lines + 1] = line
      end
    end
    return lines
  end)
  if not ok then
    return {}
  end
  return result
end

function M.append_line(path, line)
  local lines = M.load_file(path)
  table.insert(lines, 1, line)
  vim.fn.writefile(lines, path)
end

return M

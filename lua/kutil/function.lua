local M = {}

function M.map(tbl, fn)
	local new = {}
  for _, v in ipairs(tbl) do
    table.insert(new, fn(v))
  end
  return new
end

return M

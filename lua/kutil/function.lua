local M = {}

function M.map(tbl, fn)
  local new = {}
  for _, v in ipairs(tbl) do
    table.insert(new, fn(v))
  end
  return new
end

-- キーワード付き配列を分解するやつ
-- {1, 2, a = 3} => {1, 2}, {a = 3}
function M.partition_keyvalue(tbl)
  local ip = {}
  local kv = {}
  for k, v in pairs(tbl) do
    if type(k) == 'number' then
      ip[k] = v
    else
      kv[k] = v
    end
  end
  return ip, kv
end

return M

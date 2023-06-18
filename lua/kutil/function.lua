local M = {}

function M.empty(tbl)
  for _ in pairs(tbl) do
    return false
  end
  return true
end

function M.map(tbl, fn)
  local new = {}
  for _, v in ipairs(tbl) do
    table.insert(new, fn(v))
  end
  return new
end

function M.copy(tbl)
  local new = {}
  for k, v in pairs(tbl) do
    new[k] = v
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

-- aにbを足す感じで
function M.deep_extend(a, b, keep)
  if type(a) == 'table' and type(b) == 'table' and not M.empty(b) then
    local new = {}
    for k, v in pairs(a) do
      new[k] = v
    end
    for k, v in pairs(b) do
      new[k] = M.deep_extend(new[k], v, keep)
    end
    return new
  end
  if a == nil then
    return b
  end
  if b == nil then
    return a
  end
  return keep and a or b
end

return M

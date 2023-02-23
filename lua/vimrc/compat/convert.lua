-- Lua value to Vim script value converter for if_lua

-- hack
vim.type_idx = true
vim.types = {
  [3] = "float",
  [5] = "array",
  [6] = "dictionary",
  array = 5,
  dictionary = 6,
  float = 3
}
vim.empty_dict = function()
  return {
    [vim.type_idx] = vim.types.dictionary
  }
end

local M = {}

local function islist(tbl)
  if tbl[vim.type_idx] ~= nil then
    return tbl[vim.type_idx] == vim.types.array
  end
  local nums = 0
  local others = 0
  for k in pairs(tbl) do
    if type(k) == 'number' then
      nums = nums + 1
    else
      others = others + 1
    end
  end
  return others == 0 and nums == #tbl
end

local map = require('kutil.function').map

function M.convert(obj)
  if type(obj) == 'table' then
    local newobj = {}
    for k, v in pairs(obj) do
      newobj[k] = M.convert(v)
    end
    if islist(newobj) then
      return vim.list(newobj)
    else
      return vim.dict(newobj)
    end
    return newobj
  end
  return obj
end

local u = unpack or table.unpack

M.fn = setmetatable({}, {
  __index = function(_, k)
    return function(...)
      local newtable = { ... }
      return vim.fn[k](u(map(newtable, M.convert)))
    end
  end,
  __newindex = function() end,
})

function M.call(fn, ...)
  return M.fn[fn](...)
end

-- if_luaでv:falseが0になってLuaでtrue扱いされるので変換するやつ
M.booled = function(fn)
  return function()
    local ret = fn()
    return ret ~= 0 and ret
  end
end

-- if_luaのイテレータとipairsのIFが違うので潰す
-- ipairsの方が当然ながら速いしそっちに寄せる
function M.iter(list)
  if type(list) == 'table' then
    return ipairs(list)
  else
    local iter = list()
    local count = 0
    return function()
      local v = iter()
      if v ~= nil then
        count = count + 1
        return count, v
      end
      return nil, nil
    end
  end
end

return M

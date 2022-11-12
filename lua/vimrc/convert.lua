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

return M

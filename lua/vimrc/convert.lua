-- Lua value to Vim script value converter for if_lua

local M = {}

local function islist(tbl)
  local nums = 0
  local others = 0
  for k, v in pairs(tbl) do
    if type(k) == 'number' then
      nums = nums + 1
    else
      others = others + 1
    end
  end
  return others == 0 and nums == #tbl
end

local function map(tbl, fn)
  local new = {}
  for _, v in ipairs(tbl) do
    table.insert(new, fn(v))
  end
  return new
end

if vim.fn.has('nvim') == 1 then
  -- Neovimだと組み込みでよしなにしてくれるので何もしない
  function M.convert(obj)
    return obj
  end

  M.fn = vim.fn
  M.call = vim.call
else
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
end

return M

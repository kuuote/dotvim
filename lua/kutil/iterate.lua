local Iter

local msg = 'kutil:iterate stop'
local msgpat = 'kutil:iterate stop$'

local function stop()
  error(msg)
end

-- ipairsをwrapすると速い
-- 条件分岐が存在すると遅くなるのでソーステーブルが終わった段階で例外を投げて大域脱出を行う
-- そうすると変換アクションから分岐を省ける
local function wipairs(tbl)
  local f, s, v = ipairs(tbl)
  local vv
  return function()
    v, vv = f(s, v)
    if v == nil then
      stop()
    end
    return vv
  end
end

---@class Iter
---@field iter unknown
---@field next fun(self: Iter, action: fun(unknown):unknown): Iter
---@field collect fun(self: Iter): unknown[]

---@type Iter
Iter = {
  __index = function(_, key)
    return Iter[key]
  end,

  next = function(self, action)
    return setmetatable({
      iter = action(self.iter),
    }, Iter)
  end,

  collect = function(self)
    local tbl = {}
    local _, result = pcall(function()
      while true do
        table.insert(tbl, self.iter())
      end
    end)
    if tostring(result):match(msgpat) == nil then
      error(result)
    end
    return tbl
  end,
}

local M = {
  new = function(tbl)
    return setmetatable({
      iter = wipairs(tbl),
    }, Iter)
  end,

  map = function(fn)
    return function(iter)
      return function()
        return fn(iter())
      end
    end
  end,

  filter = function(fn)
    return function(iter)
      local f
      -- filterだと1回呼ばれるかそうじゃないかくらいなので毎回while使おうと遅くなる
      -- そのためtailcallスタイルにしておく
      f = function()
        local v = iter()
        if fn(v) then
          return v
        end
        return f()
      end
      return f
    end
  end,
}

return M

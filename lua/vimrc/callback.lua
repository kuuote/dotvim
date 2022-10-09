local M = {}

local callback = {}
local id = 1

function M.register(fn)
  local cid = id
  id = id + 1
  callback[cid] = fn
  return cid
end

function M.call(id)
  callback[id]()
end

return M

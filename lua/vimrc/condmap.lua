local define = require('vimrc.compat.map').define

-- 条件で評価対象が変わる複数のmapを同じキーに振れるようにする
-- 今の所expr限定になっている

local M = {
  prior = {
    vsnip = 1,
    completion = 2,
    lexima = 3,
    fallback = 9999,
  }
}

local map = {}

-- cond must be returns bool value
-- fn must be returns string value as <expr> result
function M.define(opts)
  local mode = opts.mode or { 'i' }
  local key = opts.key or error()
  local lhs = opts.lhs or error()
  local cond = opts.cond or function() return true end
  local fn = opts.fn or error()
  local priority = opts.priority or M.prior.normal
  if type(mode) == 'string' then
    mode = { mode }
  end
  for _, m in ipairs(mode or {}) do
    map[m] = map[m] or {}
    map[m][lhs] = map[m][lhs] or {}
    map[m][lhs][key] = {
      cond = cond,
      fn = fn,
      priority = priority,
    }
    define(m, lhs, function()
      return require('vimrc.condmap').eval(m, lhs)
    end, {
      desc = 'condmap ' .. lhs,
      expr = true,
      replace_keycodes = false,
      silent = true,
    })
  end

end

function M.eval(mode, lhs)
  local tbl = {}
  for key, d in pairs(map[mode][lhs]) do
    tbl[#tbl + 1] = {key, d}
  end
  table.sort(tbl, function(a, b)
    if a[2].priority == b[2].priority then
      return a[1] < b[1]
    end
    return a[2].priority < b[2].priority
  end)
  for _, p in ipairs(tbl) do
    if p[2].cond() then
      return p[2].fn() or ''
    end
  end
end

return M

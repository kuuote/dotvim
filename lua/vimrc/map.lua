local fn = vim.fn

local M = {}

M.fns = {}

M.define = function(mode, lhs, rhs, opts)
  if fn.has('nvim') == 1 then
    vim.keymap.set(mode, lhs, rhs, opts)
  else
    if type(mode) == 'string' then
      mode = {mode}
    end
    if type(rhs) == 'function' then
      local hash = fn.sha256(lhs)
      M.fns[hash] = rhs
      rhs = string.format("lua require('vimrc.map').fns['%s']", hash)
    end
    opts = opts or {}
    for _, m in ipairs(mode) do
      local cmd = string.format('%snoremap %s %s', m, lhs, rhs)
      vim.command(cmd)
    end
  end
end

return M

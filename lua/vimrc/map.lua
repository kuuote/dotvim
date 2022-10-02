local fn = vim.fn

local M = {}

M.fns = {}
local fnidx = 1

M.define = function(mode, lhs, rhs, opts)
  if fn.has('nvim') == 1 then
    vim.keymap.set(mode, lhs, rhs, opts)
  else
    if type(mode) == 'string' then
      mode = {mode}
    end

    if type(rhs) == 'function' then
      M.fns[fnidx] = rhs
      rhs = string.format("<Cmd>lua require('vimrc.map').fns[%d]()<CR>", fnidx)
      fnidx = fnidx + 1
    end

    opts = opts or {}
    local mods = ''

    for _, m in ipairs({'buffer', 'nowait', 'silent', 'script', 'expr'}) do
      if opts[m] then
        mods = mods .. '<' .. m .. '>'
      end
    end

    for _, m in ipairs(mode) do
      local cmd = string.format('%snoremap %s %s %s', m, mods, lhs, rhs)
      vim.command(cmd)
    end
  end
end

return M

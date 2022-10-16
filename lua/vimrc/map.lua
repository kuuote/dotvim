local callback = require('vimrc.callback')

local M = {}

if vim.fn.has('nvim') == 1 then
  M.define = vim.keymap.set
else
  M.define = function(mode, lhs, rhs, opts)
    if type(mode) == 'string' then
      mode = { mode }
    end

    opts = opts or {}

    if type(rhs) == 'function' then
      local id = callback.register(rhs)
      if opts.expr then
        rhs = string.format([[luaeval("require('vimrc.callback').call(%d)")]], id)
      else
        rhs = string.format([[<Cmd>lua require('vimrc.callback').call(%d)<CR>]], id)
      end
    end

    local mods = ''

    for _, m in ipairs({ 'buffer', 'nowait', 'silent', 'script', 'expr' }) do
      if opts[m] then
        mods = mods .. '<' .. m .. '>'
      end
    end
    local remap = 'nore'
    if opts.remap then
      remap = ''
    end

    for _, m in ipairs(mode) do
      local cmd = string.format('%s%smap %s %s %s', m, remap, mods, lhs, rhs)
      vim.command(cmd)
    end
  end
end

return M

local cb = require('vimrc.callback')
local copy = require('kutil.function').copy
local part = require('kutil.function').partition_keyvalue

local M = {}

if vim.fn.has('nvim') == 1 then
  function M.define(name, command, opts)
    if type(name) == "table" then
      -- {name, command, opt = xxx} pattern
      local a, o = part(name)
      opts = o
      name, command = unpack(a)
    else
      opts = opts and copy(opts) or {}
    end
    local buffer = opts.buffer
    opts.buffer = nil
    if buffer then
      vim.api.nvim_buf_create_user_command(0, name, command, opts)
    else
      vim.api.nvim_create_user_command(name, command, opts)
    end
  end
else
  function M.define(name, command, opts)
    if type(name) == "table" then
      -- {name, command, opt = xxx} pattern
      local a, o = part(name)
      opts = o
      name, command = unpack(a)
    else
      opts = opts and copy(opts) or {}
    end

    if type(command) == 'function' then
      local id = cb.register(command)
      command = ([[lua require('vimrc.callback').call(%d)]]):format(id)
    end

    vim.command(('command! %s %s'):format(name, command))
  end
end

return M

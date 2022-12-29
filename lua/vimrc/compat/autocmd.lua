local callback = require('vimrc.callback')
local vimcall = require('vimrc.compat.convert').call

local M = {}

-- autocmd用コンパチブルレイヤー
-- コールバックの引数は実装してないのでexpandで何とかしてくれ

if vim.fn.has('nvim') == 1 then
  M.group = vim.api.nvim_create_augroup
  M.define = vim.api.nvim_create_autocmd
else
  function M.group(group_name, opts)
    vim.command('augroup ' .. group_name)
    if opts.clear ~= false then
      vim.command('autocmd!')
    end
    vim.command('augroup END')
  end
  function M.define(event, opts)
    opts = require('kutil.function').copy(opts or {})
    local command = opts.command
    if type(opts.callback) == 'string' then
      command = string.format('call %s()', opts.callback)
    end
    if type(opts.callback) == 'function' then
      local id = callback.register(opts.callback)
      command = string.format("lua require('vimrc.callback').call(%d)", id)
    end
    opts.event = event
    opts.cmd = command
    vimcall('autocmd_add', {opts})
  end
end

return M

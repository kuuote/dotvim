local nvim = vim.fn.has('nvim') == 1
local callback = require('vimrc.callback')

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
    if type(event) == 'table' then
      event = table.concat(event, ',')
    end
    opts = opts or {}
    local group = opts.group or ''
    local pattern = opts.pattern or '*'
    if type(pattern) == 'table' then
      pattern = table.concat(pattern, ':')
    end
    local command = opts.command
    if type(opts.callback) == 'string' then
      command = string.format('call %s()', opts.callback)
    end
    if type(opts.callback) == 'function' then
      local id = callback.register(opts.callback)
      command = string.format("lua require('vimrc.callback').call(%d)", id)
    end
    local cmd = string.format('autocmd %s %s %s %s', group, event, pattern, command)
    vim.command(cmd)
  end
end

return M

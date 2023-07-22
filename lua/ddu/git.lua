local extend = require('kutil.function').deep_extend
local ddu = require('ddu')

local M = {}

function M.git_status()
  ddu.start(extend({
    'git_status',
    name = 'git_status',
    sourceOptions = {
      git_status = {
        path = vim.fn.expand('%:p'),
      },
    },
  }, ddu.preset.auto_preview))
end

function M.git_diff(params)
  params = params or {}
  ddu.start(extend({
    {
      name = 'git_diff',
      params = params,
      options = {
        path = vim.fn.expand('%:p'),
      },
    },
    name = 'file:git_diff',
  }, ddu.preset.auto_preview))
end

function M.git_diff_buffer()
  ddu.start(extend({
    'git_diff_buffer',
    name = 'file',
  }, ddu.preset.auto_preview))
end

return M

local extend = require('kutil.function').deep_extend
local ddu = require('ddu')

local M = {}

M.code_action = function(preview)
  local opt = {
    'lsp_codeAction',
    kindOptions = {
      lsp_codeAction = {
        defaultAction = 'apply',
      },
    },
  }
  if preview then
    opt = extend(opt, ddu.preset.auto_preview)
  end
  ddu.start(opt)
end

return M

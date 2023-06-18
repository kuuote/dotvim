-- ddu adapter by me

local vimcall = require('vimrc.compat.convert').call

local M = {}

M.preset = {}

M.preset.auto_preview = {
  uiParams = {
    ff = {
      autoAction = {
        name = 'preview',
      },
    },
  },
}

function M.start(config)
  local sources = {}
  local tableconfig = {}

  for k, v in pairs(config) do
    if type(k) == 'number' then
      sources[k] = type(v) == 'string' and { name = v } or v
    else
      tableconfig[k] = v
    end
  end

  tableconfig.sources = sources
  vimcall('ddu#start', tableconfig)
end

return M

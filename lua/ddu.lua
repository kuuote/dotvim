-- ddu adapter by me

local vimcall = require('vimrc.convert').call

local M = {}

function M.start(config)
  local sources = {}
  local tableconfig = {}

  for k, v in pairs(config) do
    if type(k) == 'number' then
      sources[k] = type(v) == 'string' and {name = v} or v
    else
      tableconfig[k] = v
    end
  end
  -- sourceOptions
  tableconfig.sourceOptions = tableconfig.sourceOptions or {}
  for _, s in ipairs(sources) do
    if s.sourceOptions ~= nil then
      tableconfig.sourceOptions[s.name] = s.sourceOptions
    end
  end
  tableconfig.sources = sources
  vimcall('ddu#start', tableconfig)
end

return M

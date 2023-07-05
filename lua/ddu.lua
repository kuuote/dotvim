-- ddu adapter by me

local vimx = require('artemis')

local M = {}

M.preset = {}

M.preset.auto_preview = {
  uiParams = {
    ff = {
      startAutoAction = true,
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
  -- 設定読み込みまで起動を遅延する
  -- ddu.tsも参照
  -- original: https://github.com/4513ECHO/dotfiles/commit/ac9499019f62d6ec0fee9f2b008610077f7dee9a
  if not vim.g.ddu_config_loaded then
    vimx.create_autocmd('User', {
      pattern = 'DduConfigLoaded',
      callback = function()
        vimx.fn.ddu.start(tableconfig)
      end,
      once = true,
    })
  else
    vimx.fn.ddu.start(tableconfig)
  end
end

return M

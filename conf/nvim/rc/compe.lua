local vimx = require('artemis')

-- change cmp <=> ddc

local is_available = vimx.fn.dein.is_available
if is_available('ddc.vim') == 0 then
  require('cmp')
  vim.g.cmp = true
  return
end

local current = 'ddc'
local ddc_config

vim.keymap.set('n', '<C-c>', function()
  require('cmp')
  if current == 'ddc' then
    ddc_config = vimx.fn.ddc.custom.get_global()
    vimx.fn.ddc.custom.set_global({ui = 'none'})
    vim.g.cmp = true
    current = 'cmp'
  else
    vimx.fn.ddc.custom.set_global(ddc_config)
    vim.g.cmp = false
    current = 'ddc'
  end
  print('Change completion engine to ' .. current)
end)

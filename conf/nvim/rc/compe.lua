-- change cmp <=> ddc

local current = 'ddc'

vim.keymap.set('n', '<C-c>', function()
  require('cmp')
  if current == 'ddc' then
    vim.call('ddc#custom#set_global', {ui = 'none'})
    vim.g.cmp = true
    current = 'cmp'
  else
    vim.call('ddc#custom#set_global', vim.g['vimrc#ddc_config'])
    vim.g.cmp = false
    current = 'ddc'
  end
  print('Change completion engine to ' .. current)
end)

colorscheme catppuccin-mocha

lua <<EOF
if is_nvim then
  -- Capture lua =require('catppuccin.palettes').get_palette('mocha')
  local mocha = require('catppuccin.palettes').get_palette('mocha')
  vim.api.nvim_set_hl(0, 'Pmenu', { fg = mocha.mauve, bg = '#2b2b3c' })
  vim.api.nvim_set_hl(0, 'PmenuSel', { fg = mocha.crust, bg = mocha.red })
  vim.api.nvim_set_hl(0, 'FuzzyAccent', { fg = mocha.green })
  vim.api.nvim_set_hl(0, 'FuzzyMotionChar', { fg = mocha.green })
  vim.api.nvim_set_hl(0, 'FuzzyMotionSubChar', { fg = mocha.peach })
  vim.api.nvim_set_hl(0, 'FuzzyMotionMatch', { fg = mocha.blue })
end
EOF

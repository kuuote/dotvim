colorscheme catppuccin-mocha

lua <<EOF
if isnvim then
  local mocha = require('catppuccin.palettes').get_palette('mocha')
  vim.api.nvim_set_hl(0, 'FuzzyMotionChar', { fg = mocha.green })
  vim.api.nvim_set_hl(0, 'FuzzyMotionSubChar', { fg = mocha.peach })
  vim.api.nvim_set_hl(0, 'FuzzyMotionMatch', { fg = mocha.blue })
end
EOF

colorscheme catppuccin-latte

lua <<EOF
if is_nvim then
  local latte = require('catppuccin.palettes').get_palette('latte')
  vim.api.nvim_set_hl(0, 'FuzzyMotionChar', { fg = latte.red })
  vim.api.nvim_set_hl(0, 'FuzzyMotionSubChar', { fg = latte.teal })
  vim.api.nvim_set_hl(0, 'FuzzyMotionMatch', { fg = latte.lavender })
  vim.api.nvim_set_hl(0, 'FuzzyMotionShade', { fg = latte.surface1 })
end
EOF

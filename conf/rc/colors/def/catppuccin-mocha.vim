call dpp#source('catppuccin')
set background=dark
colorscheme catppuccin-mocha

lua <<EOF
if vim.fn.has('nvim') == 1 then
  -- Capture lua =require('catppuccin.palettes').get_palette('mocha')
  local mocha = require('catppuccin.palettes').get_palette('mocha')
  vim.api.nvim_set_hl(0, 'Pmenu', { fg = mocha.mauve, bg = '#2b2b3c' })
  vim.api.nvim_set_hl(0, 'PmenuSel', { fg = mocha.crust, bg = mocha.red })
  vim.api.nvim_set_hl(0, 'PumHighlight', { fg = mocha.green })
  vim.api.nvim_set_hl(0, 'FuzzyMotionChar', { fg = mocha.green })
  vim.api.nvim_set_hl(0, 'FuzzyMotionSubChar', { fg = mocha.peach })
  vim.api.nvim_set_hl(0, 'FuzzyMotionMatch', { fg = mocha.blue })
  vim.cmd('hi link @text.diff.delsign diffOldFile')
  vim.cmd('hi link @text.diff.addsign diffNewFile')
  vim.cmd('hi link @text.diff.indicator PmenuSbar')
end
EOF

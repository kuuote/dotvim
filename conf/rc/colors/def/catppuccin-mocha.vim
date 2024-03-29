function s:on_color_scheme() abort
  " Vimで反転するので防止
  hi IncSearch cterm=NONE gui=NONE
  hi link DiffIndicator PmenuSbar
  if has('nvim')
    lua <<EOF
    -- Capture lua =require('catppuccin.palettes').get_palette('mocha')
    local mocha = require('catppuccin.palettes').get_palette('mocha')
    vim.api.nvim_set_hl(0, 'Pmenu', { fg = mocha.mauve, bg = '#2b2b3c' })
    vim.api.nvim_set_hl(0, 'PmenuSel', { fg = mocha.crust, bg = mocha.red })
    vim.api.nvim_set_hl(0, 'PumHighlight', { fg = mocha.green })
    vim.api.nvim_set_hl(0, 'FuzzyMotionChar', { fg = mocha.green })
    vim.api.nvim_set_hl(0, 'FuzzyMotionSubChar', { fg = mocha.peach })
    vim.api.nvim_set_hl(0, 'FuzzyMotionMatch', { fg = mocha.blue })
    vim.api.nvim_set_hl(0, '@text.diff.delindicator', { fg = mocha.yellow, bg = mocha.surface1 })
    vim.api.nvim_set_hl(0, '@text.diff.addindicator', { fg = mocha.peach, bg = mocha.surface1 })
    vim.cmd('hi link @text.diff.delsign diffOldFile')
    vim.cmd('hi link @text.diff.addsign diffNewFile')
    vim.cmd('hi link @text.diff.indicator PmenuSbar')
EOF
  endif
endfunction

autocmd persistent_colorscheme ColorScheme catppuccin-mocha call s:on_color_scheme()

call dpp#source('catppuccin')
set background=dark
colorscheme catppuccin-mocha

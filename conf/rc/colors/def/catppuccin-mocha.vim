function s:on_colors() abort
  " Vimで反転するので防止
  hi IncSearch cterm=NONE gui=NONE
  hi link DiffIndicator PmenuSbar
  lua <<EOF
    local cmd = vim.cmd or vim.command
    local mocha = require('catppuccin.palettes').get_palette('mocha')
    cmd(('hi %s guifg=%s'):format('PumHighlight', mocha.green))
    cmd(('hi %s guifg=%s guibg=%s'):format('Pmenu', mocha.mauve, '#2b2b3c'))
    cmd(('hi %s guifg=%s guibg=%s'):format('PmenuSel', mocha.crust, mocha.red))
    cmd(('hi %s guifg=%s'):format('FuzzyMotionChar', mocha.green))
    cmd(('hi %s guifg=%s'):format('FuzzyMotionSubChar', mocha.peach))
    cmd(('hi %s guifg=%s'):format('FuzzyMotionMatch', mocha.blue))
EOF
  if has('nvim')
    lua <<EOF
    -- Capture lua =require('catppuccin.palettes').get_palette('mocha')
    local mocha = require('catppuccin.palettes').get_palette('mocha')
    vim.api.nvim_set_hl(0, '@text.diff.delindicator', { fg = mocha.yellow, bg = mocha.surface1 })
    vim.api.nvim_set_hl(0, '@text.diff.addindicator', { fg = mocha.peach, bg = mocha.surface1 })
    vim.cmd('hi link @text.diff.delsign diffOldFile')
    vim.cmd('hi link @text.diff.addsign diffNewFile')
    vim.cmd('hi link @text.diff.indicator PmenuSbar')
EOF
  endif
endfunction

autocmd persistent_colorscheme ColorScheme catppuccin-mocha call s:on_colors()

set background=dark
colorscheme catppuccin-mocha

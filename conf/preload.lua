-- global variables
_G.is_nvim = vim.fn.has('nvim') == 1

if is_nvim then
  require('vimrc.preload.nvim')
else
end

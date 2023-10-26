vim.ui.select = function(...)
  vim.ui.select = error
  require('vimrc.ui_select')
  vim.ui.select(...)
end

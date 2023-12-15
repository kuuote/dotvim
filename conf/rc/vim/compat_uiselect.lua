vim.ui = {
  select = function(...)
    vim.ui.select = require('vimrc.feat.ui_select_fzf')
    vim.ui.select(...)
  end
}

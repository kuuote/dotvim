vim.notify = function(...)
  vim.notify = require('vimrc.feat.notify').notify
  vim.notify(...)
end

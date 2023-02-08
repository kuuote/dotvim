local iter = require('kutil.iterate')

local M = {}

function M.act(cmd)
  local pw = iter.new(vim.fn.getwininfo())
  :next(iter.filter(function(w)
    return vim.fn.getwinvar(w.winid, '&previewwindow') == 1
  end)):collect()[1]
  if pw == nil then
    vim.pretty_print('pw == nil')
    return
  end
  vim.fn.win_execute(pw.winid, cmd)
end

return M

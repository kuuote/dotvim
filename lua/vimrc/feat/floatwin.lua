local M = {}

---@param cmd string
---@return number
function M.open(cmd)
  local winid = vim.api.nvim_open_win(vim.fn.bufnr(), true, {
    relative = 'editor',
    row = 2,
    col = 2,
    width = vim.o.columns - 4 - 2,
    height = vim.o.lines - 4 - 2,
    border= {'+', '-', '+', '|', '+', '-', '+', '|'},
  })
  vim.cmd.lcd(vim.fn.expand('%:p:h'))
  vim.wo[0].winhighlight = 'NormalFloat:Normal,EndOfBuffer:,FloatBorder:Normal'
  vim.cmd(cmd)
  return winid
end

return M

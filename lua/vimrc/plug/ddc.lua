local au = require('vimrc.compat.autocmd').define
local vimcall = require('vimrc.compat.convert').call

local M = {
  auto_reset = true,
}

local customs = {}

function M.save_buffer()
  local bufnr = vim.fn.bufnr()
  if customs[bufnr] == nil then
    customs[bufnr] = vimcall('ddc#custom#get_buffer')
  end
end

function M.reset_buffer()
  local bufnr = vim.fn.bufnr()
  if customs[bufnr] ~= nil then
    vimcall('ddc#custom#set_buffer', customs[bufnr])
    customs[bufnr] = nil
  end
end

au('User', {
  pattern = require('vimrc.autocmd.insert_end'),
  callback = function()
    if M.auto_reset then
      M.reset_buffer()
    end
  end,
})
au('BufEnter', {
  callback = function()
    if M.auto_reset then
      M.reset_buffer()
    end
  end,
})

return M

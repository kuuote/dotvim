local M = {}

local eval = vim.eval or vim.api.nvim_eval


local pum_vim_confirm = eval([["\<Cmd>call pum#map#confirm()\<CR>"]])

function M.pum_confirm(fallback)
  if vim.fn.pumvisible() == 1 then
    if vim.fn.complete_info().selected ~= -1 then
      return '\25' -- <C-y>
    end
  end
  local ok, result = pcall(vim.fn['pum#visible'])
  if ok and result == 1 then
    if vim.call('pum#complete_info').selected ~= -1 then
      return pum_vim_confirm
    end
  end
  return fallback()
end

return M

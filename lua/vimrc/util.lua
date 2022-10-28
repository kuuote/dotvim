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

function M.find_root(path)
  path = path or vim.fn.expand('%:p')
  if path == '' then
    path = vim.fn.getcwd() -- ファイルが開かれていない場合はcwdを使う
  elseif vim.fn.isdirectory(path) == 0 then
    path = vim.fn.expand('%:p:h') -- パスがファイルであればその親を取る
  end
  local found = vim.fn.finddir('.git/..', path .. ';') -- gitリポジトリの中であれば、そのrootを取る
  if found ~= '' then
    path = found
  end
  return path
end

return M

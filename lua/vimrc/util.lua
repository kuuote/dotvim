local M = {}

local cmd = vim.command or vim.cmd
local eval = vim.eval or vim.api.nvim_eval

function M.find_root(path)
  path = path or vim.fn.expand('%:p')
  if path == '' then
    path = vim.fn.getcwd() -- ファイルが開かれていない場合はcwdを使う
  elseif vim.fn.isdirectory(path) == 0 then
    path = vim.fn.expand('%:p:h') -- パスがファイルであればその親を取る
  end
  local found = vim.fn.finddir('.git/..', path .. ';') -- gitリポジトリの中であれば、そのrootを取る
  if found ~= '' then
    path = vim.fn.fnamemodify(found, ':p')
  end
  return path
end

-- 辞書の中に値を配置するやつ
function M.let(path, obj)
  vim.g['LuaTemp'] = obj
  cmd(string.format('let %s = g:LuaTemp', path))
  cmd('unlet g:LuaTemp')
end

return M

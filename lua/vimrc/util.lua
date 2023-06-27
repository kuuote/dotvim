local M = {}

local cmd = vim.command or vim.cmd

function M._get_current_dir(path)
  if not path:match('^/') then
    path = vim.fn.getcwd() -- 実パスを指してなければcwdと置換
  elseif vim.fn.isdirectory(path) == 0 then
    path = vim.fn.expand('%:p:h') -- パスがファイルであればその親を取る
  end
  return path
end

local temporaly_roots = {}

-- 一時的なroot dirを追加する
function M.add_root()
  table.insert(temporaly_roots, M._get_current_dir())
  table.sort(temporaly_roots, function(a, b)
    local sa = #a - #b
    if sa == 0 then
      return a < b
    end
    -- 長い方優先
    return #a > #b
  end)
end

-- 一時的なroot dirを削除する
-- recursiveにtrueを渡すとカレントディレクトリ以下も全て吹き飛ばす
function M.remove_root(recursive)
  local path = M._get_current_dir()
  local i = require('kutil.iterate')
  temporaly_roots = i.new(temporaly_roots)
    :next(i.filter(function(root)
      if recursive then
        return root:sub(1, #path) == path
      else
        return root == path
      end
    end))
    :collect()
end

function M.find_root(path)
  if path == nil then
    path = vim.fn.bufname('%')
  end
  -- gin.vim
  local match = path:match('gin%a+://([^;]+)')
  if match ~= nil then
    return match
  end

  local dir = M._get_current_dir(path)
  for _, r in ipairs(temporaly_roots) do
    if dir:sub(1, #r) == r then
      return r
    end
  end
  local found = vim.fn.finddir('.git/..', dir .. ';') -- gitリポジトリの中であれば、そのrootを取る
  if found ~= '' then
    dir = vim.fn.fnamemodify(found, ':p')
  end
  return dir
end

-- 辞書の中に値を配置するやつ
function M.let(path, obj)
  vim.g['LuaTemp'] = obj
  cmd(([[
if exists('g:LuaTemp')
  let %s = g:LuaTemp
  unlet g:LuaTemp
else
  silent! unlet %s
endif
  ]]):format(path, path))
end

return M

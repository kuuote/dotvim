local tmpdir = vim.fn.tempname()
vim.fn.mkdir(tmpdir)
local tmpcount = 0
local function tempfile()
  tmpcount = tmpcount + 1
  return tmpdir .. '/' .. tmpcount
end

-- vim list to ipairs
local function iter(list)
  if type(list) == 'table' then
    return ipairs(list)
  else
    local iter = list()
    local count = 0
    return function()
      local v = iter()
      if v ~= nil then
        count = count + 1
        return count, v
      end
      return nil, nil
    end
  end
end

return function(items, opts, on_choice)
  local format_item = opts.format_item or tostring
  local formatted = {}
  for idx, item in iter(items) do
    formatted[idx] = idx .. ': ' .. format_item(item)
  end

  -- execute fzf in vim
  local winid = vim.fn.win_getid()
  vim.command('tabnew')

  local infile = tempfile()
  local outfile = tempfile()
  vim.fn.writefile(vim.list(formatted), infile)

  local termbuf
  termbuf = vim.fn.term_start(
    ('sh -c "cat %s | fzf --layout=reverse > %s"'):format(infile, outfile),
    vim.dict {
      curwin = true,
      exit_cb = function()
        vim.fn.win_gotoid(winid)
        vim.command('bdelete ' .. termbuf)
        local f = function()
          for idx, result in iter(vim.fn.readfile(outfile)) do
            local found = result:find(':')
            local idx = tonumber(result:sub(1, result:find(':') - 1))
            return on_choice(items[idx], idx)
          end
          on_choice() -- cancel
        end
        f()
        vim.fn.delete(infile)
        vim.fn.delete(outfile)
      end,
    }
  )
end

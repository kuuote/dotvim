local au = require('vimrc.autocmd').define
local fn = vim.fn

-- シバン付いてるファイルに実行権限を与える
au('BufWritePost', {
  callback = function()
    if fn.getline(1):sub(1, 2) == '#!' then
      local file = fn.expand('<afile>')
      local perm = fn.getfperm(file)
      local newperm = string.format('%sx%sx%sx', perm:sub(1, 2), perm:sub(4, 5), perm:sub(7, 8))
      if perm ~= newperm then
        fn.setfperm(file, newperm)
        print('Set executable: ' .. file)
      end
    end
  end,
})

-- auto mkdir
au('BufWritePre', {
  callback = function()
    local dir = fn.expand('<afile>:p:h')
    if fn.isdirectory(dir) == 0 then
      if fn.confirm(dir .. ' is not found. create it?', '&Yes\n&No', 2) == 1 then
        fn.mkdir(dir, 'p')
      end
    end
  end,
})

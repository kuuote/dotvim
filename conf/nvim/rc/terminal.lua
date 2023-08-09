local vimx = require('artemis')
-- vim.keymap.set('n', 'T', function()
--   local dir = vim.fn.expand('%:p:h')
--   local buf = vim.api.nvim_create_buf(false, true)
--   vim.api.nvim_create_autocmd('BufWinLeave', {
--     buffer = buf,
--     callback = vim.schedule_wrap(function()
--       vim.cmd('bwipeout!' .. buf)
--     end),
--   })
--
--   vim.api.nvim_open_win(buf, true, {
--     relative = 'editor',
--     style = 'minimal',
--     width = vim.opt.columns:get(),
--     height = 1,
--     row = vim.opt.lines:get() / 2,
--     col = 0,
--   })
--   vim.cmd('startinsert!')
--
--   if not pcall(vim.cmd, 'lcd ' .. dir) then
--     dir = vim.fn.getcwd()
--   end
--
--   if vim.g.cmp then
--     require('cmp').setup.buffer {
--       sources = {
--         { name = 'zsh' },
--         { name = 'path' },
--       },
--     }
--   else
--     vim.call('ddc#custom#set_buffer', {
--       sources = { 'zsh', 'file' },
--       specialBufferCompletion = true,
--     })
--   end
--
--   local opts = {
--     buffer = buf,
--     nowait = true,
--   }
--   vim.keymap.set('n', '<Esc>', '<Cmd>close<CR>', opts)
--   vim.keymap.set('i', '<CR>', function()
--     local cmd = vim.fn.getline('.')
--     vim.cmd.stopinsert()
--     vim.cmd.close()
--     vim.cmd('-tab split')
--     vim.cmd('tcd ' .. dir)
--     vim.cmd.terminal(cmd)
--
--     local t = vim.fn.reltime()
--     vim.api.nvim_create_autocmd('TermClose', {
--       buffer = 0,
--       callback = function()
--         -- 1秒以上実行に時間がかかった場合、終了時に通知を出す
--         if vim.fn.reltimefloat(vim.fn.reltime(t)) < 1 then
--           return
--         end
--         vim.notify(([[done '%s']]):format(cmd))
--       end,
--     })
--
--     vim.api.nvim_feedkeys('G', 'n', false)
--   end, opts)
-- end)

local dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'operandi')
vim.fn.mkdir(dir, 'p')
local file = vim.fs.joinpath(dir, 'nvimterm')

local function source()
  return require('vimrc.plug.operandi').load_file(file)
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'operandi#open#terminal',
  callback = function()
    pcall(vim.cmd, 'tcd ' .. vim.fn.expand('#:p:h'))
    if vim.g.cmp then
      require('cmp').setup.buffer {
        sources = {
          { name = 'zsh' },
          { name = 'path' },
        },
      }
    else
      vim.call('ddc#custom#set_buffer', {
        sources = { 'file', 'shell-native', 'line' },
        sourceParams = {
          file = {
            projAsRoot = false,
          },
        },
        specialBufferCompletion = true,
      })
    end
  end,
})

local function executor(cmd)
  require('vimrc.plug.operandi').append_line(file, cmd)
  require('vimrc.feat.nvimterm').execute {
    cmd = cmd,
    wd = vim.fn.expand('%:p:h'),
  }
end

vim.keymap.set('n', 'ti', function()
  vimx.fn.operandi.register('terminal', {
    source = source,
    executor = executor,
  })
  vimx.fn.operandi.open('terminal')
  vimx.cmd.startinsert()
end)

local vimx = require('artemis')
local file = '/data/vimshared/nvimterm'

local function source()
  return vimx.fn.vimrc.mru.load(file)
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
    elseif vim.fn['dein#is_available']('ddc.vim') == 1 then
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
  vimx.fn.vimrc.mru.save(file, { line = cmd })
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

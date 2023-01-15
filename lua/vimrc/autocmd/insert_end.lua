local au = require('vimrc.compat.autocmd').define
local cmd = vim.command or vim.cmd

local event = 'vimrc#insert_end'
local docmd = 'doautocmd <nomodeline> User ' .. event
local called = false

au({ 'CmdlineLeave', 'InsertLeave' }, {
  callback = function()
    called = true
    -- プラグインでの呼び出しを無視するためにタイマーを挟む
    -- 一時的に切り替わった際にはmode()の結果はnではないので問題ない
    vim.fn.timer_start(0, function()
      if vim.fn.mode() == 'n' then
        -- 複数回呼ばれるケースがあるので潰しておく
        if called then
          cmd(docmd)
          called = false
        end
      end
    end)
  end,
})
return event

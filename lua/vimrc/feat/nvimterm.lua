local M = {}

M.execute = function(opts)
  if opts == nil or opts.cmd == nil then
    error('wtf?')
  end
  vim.cmd('-tab split')
  if opts.wd then
    pcall(vim.cmd.tcd(opts.wd))
  end

  vim.cmd.terminal(opts.cmd)
  local t = vim.fn.reltime()
  vim.api.nvim_create_autocmd('TermClose', {
    buffer = 0,
    callback = function()
      -- 1秒以上実行に時間がかかった場合、終了時に通知を出す
      if vim.fn.reltimefloat(vim.fn.reltime(t)) < 1 then
        return
      end
      vim.notify(([[done '%s']]):format(opts.cmd))
    end,
  })

  vim.api.nvim_feedkeys('G', 'n', false)
end

return M

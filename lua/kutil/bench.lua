return function(fn, msg)
  msg = msg or ''
  local t = vim.fn.reltime()
  local c = 0
  while vim.fn.reltimefloat(vim.fn.reltime(t)) < 0.1 do
    fn()
    c = c + 1
  end
  print(c, msg)
end

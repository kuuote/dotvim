package.preload['vimrc.compat.autocmd'] = function()
  return {
    group = vim.api.nvim_create_augroup,
    define = vim.api.nvim_create_autocmd,
  }
end

package.preload['vimrc.compat.convert'] = function()
  return {
    convert = function(obj)
      return obj
    end,
    fn = vim.fn,
    call = vim.call,
    booled = function(fn)
      return fn
    end,
    iter = ipairs,
  }
end

package.preload['vimrc.compat.map'] = function()
  return {
    define = vim.keymap.set,
  }
end

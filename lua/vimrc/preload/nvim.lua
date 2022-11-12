package.preload['vimrc.autocmd'] = function()
  return {
    group = vim.api.nvim_create_augroup,
    define = vim.api.nvim_create_autocmd,
  }
end

package.preload['vimrc.convert'] = function()
  return {
    convert = function(obj)
      return obj
    end,
    fn = vim.fn,
    call = vim.call,
  }
end

package.preload['vimrc.map'] = function()
  return {
    define = vim.keymap.set,
  }
end

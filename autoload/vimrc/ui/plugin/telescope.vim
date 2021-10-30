function! vimrc#ui#plugin#telescope#menu() abort
  let menu = {}
  for p in luaeval('vim.tbl_keys(require("telescope.builtin"))')
    let menu[p] = printf(':Telescope %s', p)
  endfor
  return menu
endfunction

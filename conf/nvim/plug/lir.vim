UsePlugin lir.nvim

lua << EOF
  local actions = require'lir.actions'

  require'lir'.setup {
    show_hidden_files = true,
    mappings = {
      ['l']     = actions.edit,
      ['<C-s>'] = actions.split,
      ['<C-v>'] = actions.vsplit,
      ['<C-t>'] = actions.tabedit,

      ['h']     = actions.up,
      ['q']     = actions.quit,

      ['K']     = actions.mkdir,
      ['N']     = actions.newfile,
      ['R']     = actions.rename,
      ['@']     = actions.cd,
      ['Y']     = actions.yank_path,
      ['.']     = actions.toggle_show_hidden,
    }
  }
EOF

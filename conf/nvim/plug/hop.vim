UsePlugin hop.nvim

lua << EOF
require("hop").setup()
EOF

nnoremap ,f <Cmd>HopChar1<CR>

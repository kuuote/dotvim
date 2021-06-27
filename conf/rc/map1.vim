" 1行マッピング
nnoremap ' :update<CR>:source %<CR>|                                          " atodekesu
nnoremap ; :|                                                                 " USキーボードだとシフトが必要で不便
nnoremap <Space>. :e ~/.vim/conf<CR>|                                         " confへのショートカット
nnoremap <Space>d :e %:p:h<CR>|                                               " 上の階層に楽に抜ける
nnoremap <Space>s :update<CR>|                                                " 素早く書き込む
nnoremap <Space>w <C-w>|                                                      " C-wは押しづらい
nnoremap <Tab> :tabnext<CR>|                                                  " Tabを押すと次のタブに飛んでほしい
nnoremap q; q:|                                                               " cmdwinは便利 USキーボードだと(ry
nnoremap Q :confirm qa<CR>|                                                  " 確認取って終了
nnoremap s <NOP>|                                                             " <Space>sやvim-sandwichを使う上で邪魔なので無効化
xnoremap ; :|                                                                 " USキーボードだと(ry
nnoremap <Space>tp <Cmd>hi Normal guibg=NONE <Bar> hi EndOfBuffer guibg=NONE<CR>| " 背景を透過する

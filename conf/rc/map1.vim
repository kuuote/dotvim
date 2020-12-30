" 1行マッピング
nnoremap ' :update<CR>:source %<CR>| " atodekesu
nnoremap ; :|                        " USキーボードだとシフトが必要で不便
nnoremap <Space>. :e $MYVIMRC<CR>|   " vimrcを編集する
nnoremap <Space>d :e %:p:h<CR>|      " 上の階層に楽に抜ける
nnoremap <Space>s :update<CR>|       " 素早く書き込む
nnoremap <Space>w <C-w>|             " C-wは押しづらい
nnoremap <Tab> :tabnext<CR>|         " Tabを押すと次のタブに飛んでほしい
nnoremap q; q:|                      " cmdwinは便利 USキーボードだと(ry
nnoremap qq :confirm qa<CR>|         " 確認取って終了
nnoremap s <NOP>|                    " <Space>sやvim-sandwichを使う上で邪魔なので無効化

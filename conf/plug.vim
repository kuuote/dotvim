call dein#add('hrsh7th/vim-vsnip') " VSCode形式を使えるスニペットプラグイン
call dein#add('junegunn/fzf') " fzf-previewの前提
call dein#add('lambdalisue/gina.vim') " Vimからgit操作するプラグイン
call dein#add('lambdalisue/suda.vim') " sudo経由でファイルを読み書きする
call dein#add('machakann/vim-sandwich') " 括弧を囲ってくれるすごいやつ
call dein#add('thinca/vim-localrc') " ローカルのvimrcを読み込んでくれる
call dein#add('thinca/vim-quickrun') " コマンドを素早く実行する
call dein#add('tyru/capture.vim') " コマンドの出力をバッファで開く
call dein#add('tyru/eskk.vim') " Nihongo Nyuuryoku suruyatu
call dein#add('yuki-ycino/fzf-preview.vim', { 'rev': 'release/rpc' }) " dark powered fzf plugin

" colorscheme
call dein#add('ghifarit53/tokyonight-vim')
call dein#add('sainnhe/edge')
call dein#add('yasukotelin/shirotelin')
call dein#add('cormacrelf/vim-colors-github')

" lsp
call dein#add('mattn/vim-lsp-settings') " vim-lspの設定をいい感じにしてくれるやつ
call dein#add('prabirshrestha/asyncomplete-lsp.vim') " asyncompleteとvim-lspの連携
call dein#add('prabirshrestha/asyncomplete.vim') " 自動補完
call dein#add('prabirshrestha/vim-lsp') " Pure Vim script LSP Client

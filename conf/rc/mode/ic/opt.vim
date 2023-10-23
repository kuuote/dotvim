" ShellScriptやVim scriptの編集に便利なので = を除外
set isfname-==

" いい感じのBackspace
set backspace=indent,eol,start

" タイムアウトを設けることによりEscを単体で入力できるようにする
set ttimeout
"" defaults.vimより
set ttimeoutlen=100

" ファイル名に記号使うよね普通に
set isfname+=@-@

" 何でも曖昧なのがいい
set wildoptions+=fuzzy

" 検索の時にケースを無視
set ignorecase
set smartcase


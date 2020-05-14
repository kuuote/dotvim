" 頑張らないブックマーク管理.vim
" 編集はvimの機能で可能なので追加機能とオープンショートカット以外は作りません

" (プラグインとして導入されていることを前提として)標準だと.vimもしくはvimfilesの直下にbookmark.lstという名前のファイルを作成する
let g:bookmark_file = get(g:, "bookmark_file", matchstr(expand("<sfile>"), '.*\(.vim\|vimfiles\)/') .. "bookmark.lst")

function! s:read() abort
  try
    " readfileはファイルを改行で区切られたリストにしてくれる
    return readfile(g:bookmark_file)
  catch
    " ファイル読めなかったら空で
    return []
  endtry
endfunction

function! bookmark#add() abort
  " ファイル名はフルパスに
  " シンボリックリンクを展開してほしければresolve()で囲えばOK
  let path = expand("%:p")
  " 既存のデータを読んで
  let old = s:read()
  " pathを一旦取り除く
  let new = filter(copy(old), "v:val != path")
  " 先頭に突っ込んで
  let new = insert(new, path)
  " 内容に相違があれば書き込む
  if old != new
    " writefileはreadfileの逆をやってくれる
    call writefile(new, g:bookmark_file)
  endif
  echo printf("Added %s", pathshorten(path))
endfunction

function! bookmark#open() abort
  " addで更新されていてもeditした時点で開き直される
  " 拡張子によってはfiletype設定されちゃうのでnoautocmd付きで開く
  noautocmd edit `=g:bookmark_file`

  " MRUっぽいやつ
  " :move 0で持ち上げて
  " :updateで変更があれば書き込みを行い
  " gfでファイルに飛ぶ
  nnoremap <buffer> <nowait> <silent> <CR> :<C-u>move 0<CR>:update<CR>gf
endfunction

nnoremap <silent> <Space>a :<C-u>call bookmark#add()<CR>
nnoremap <silent> <Space>m :<C-u>call bookmark#open()<CR>

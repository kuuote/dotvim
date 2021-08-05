let s:dein_dir = '/data/vim'

let s:dein_repo = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo)
  execute printf('!git clone https://github.com/Shougo/dein.vim %s', s:dein_repo)
endif
let &runtimepath ..= ',' .. s:dein_repo
let g:dein#auto_recache = 0
call delete('/tmp/dein/cache/updatenv', 'rf')
let g:dein#cache_directory = '/tmp/dein/cache/updatenv'

call dein#begin(s:dein_dir, [])

for s:toml in sort(glob('~/.vim/conf/**/*.toml', 1, 1))
  call dein#load_toml(s:toml)
endfor

call dein#end()

call dein#recache_runtimepath()
source ~/.vim/local/dein.vim
nnoremap U <Cmd>call dein#check_update()<CR>
nnoremap Q <Cmd>confirm qa<CR>

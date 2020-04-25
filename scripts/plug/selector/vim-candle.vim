call minpac#add('hrsh7th/vim-candle')

autocmd vimrc User candle#initialize :

autocmd vimrc User candle#start call s:on_candle_start()
function! s:on_candle_start()
  nnoremap <silent><buffer> k     :<C-u>call candle#mapping#cursor_move(-1)<CR>
  nnoremap <silent><buffer> j     :<C-u>call candle#mapping#cursor_move(1)<CR>
  nnoremap <silent><buffer> K     :<C-u>call candle#mapping#cursor_move(-10)<CR>
  nnoremap <silent><buffer> J     :<C-u>call candle#mapping#cursor_move(10)<CR>
  nnoremap <silent><buffer> gg    :<C-u>call candle#mapping#cursor_top()<CR>
  nnoremap <silent><buffer> G     :<C-u>call candle#mapping#cursor_bottom()<CR>
  nnoremap <silent><buffer> -     :<C-u>call candle#mapping#toggle_select()<CR>
  nnoremap <silent><buffer> *     :<C-u>call candle#mapping#toggle_select_all()<CR>
  nnoremap <silent><buffer> i     :<C-u>call candle#mapping#input_open()<CR>
  nnoremap <silent><buffer> a     :<C-u>call candle#mapping#input_open()<CR>
  nnoremap <silent><buffer> <Tab> :<C-u>call candle#mapping#choose_action()<CR>
  nnoremap <silent><buffer> <C-l> :<C-u>call candle#mapping#restart()<CR>

  nnoremap <silent><buffer> <CR>  :<C-u>call candle#mapping#action('default')<CR>
  nnoremap <silent><buffer> s     :<C-u>call candle#mapping#action('split')<CR>
  nnoremap <silent><buffer> v     :<C-u>call candle#mapping#action('vsplit')<CR>
  nnoremap <silent><buffer> d     :<C-u>call candle#mapping#action('delete')<CR>
endfunction
autocmd vimrc User candle#input#start call s:on_candle_input_start()
function! s:on_candle_input_start()
  cnoremap <silent><buffer> <Tab> <Esc>:<C-u>call candle#mapping#choose_action()<CR>
  cnoremap <silent><buffer> <C-y> <Esc>:<C-u>call candle#mapping#action('default')<CR>
  cnoremap <silent><buffer> <C-p> <Esc>:<C-u>call candle#mapping#cursor_move(-1) \| call candle#mapping#input_open()<CR>
  cnoremap <silent><buffer> <C-n> <Esc>:<C-u>call candle#mapping#cursor_move(+1) \| call candle#mapping#input_open()<CR>
endfunction

function! s:mru()
  call candle#start({
        \        'mru_file': {
        \          'ignore_patterns': map(
        \            range(1, tabpagewinnr(tabpagenr(), '$')),
        \            { i, winnr -> fnamemodify(bufname(winbufnr(winnr)), ':p') }
        \          )
        \        }
        \    })
endfunction

nnoremap <Space>o :<C-u>call <SID>mru()<CR>

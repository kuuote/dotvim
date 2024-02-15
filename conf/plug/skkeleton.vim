" /data/newvim/old/conf/plug/skkeleton.lua

function s:initialize() abort
  let s:dicts = [
  \   ['/data/vim/repos/github.com/skk-dev/dict/SKK-JISYO.L', 'euc-jp'],
  \ ]
  call skkeleton#config(#{
  \   eggLikeNewline: v:true,
  \   markerHenkan: '',
  \   markerHenkanSelect: '',
  \   registerConvertResult: v:true,
  \   showCandidatesCount: 1,
  \   globalDictionaries: s:dicts,
  \ })

  let s:kanatable = {}

  " USキーボードの n' で「ん」を打てるやつをJISキーボードでもやる
  let s:kanatable['n:'] = ['ん', '']

  " hokan de dasita kouho kesu
  let s:kanatable['xx'] = 'purgeCandidate'

  call skkeleton#register_kanatable('rom', s:kanatable)
endfunction
autocmd vimrc User skkeleton-initialize-pre call s:initialize()

" ddc.vim integration
autocmd vimrc User skkeleton-enable-post call ddc#custom#set_buffer(#{sources: ['skkeleton'], specialBufferCompletion: v:true})
autocmd vimrc User skkeleton-disable-post call ddc#custom#set_buffer({})

" 変換ポイント切ってる時だけcursorlineを表示する
let s:cursorline_phase = {
\   'input:okurinasi': v:true,
\   'input:okuriari': v:true,
\   'henkan': v:true,
\ }

function s:cursorline() abort
  let phase = g:skkeleton#state.phase
  if has_key(s:cursorline_phase, phase)
    setlocal cursorline
  else
    setlocal nocursorline
  endif
endfunction

autocmd vimrc User skkeleton-handled call s:cursorline()
autocmd vimrc User skkeleton-disable-post setlocal nocursorline

function s:azik() abort
  call skkeleton#azik#add_table('us')
  call skkeleton#config(#{kanaTable: 'azik'})
  " base: https://github.com/NI57721/dotfiles/blob/79d2decf4b1e2bf5522c3af5f0ffdefd87b7ff50/.config/vim/vimrc#L378
  " sticky keyが無いと生きていけない
  call skkeleton#register_kanatable('azik', {"'": 'disable'})
  call skkeleton#register_kanatable('azik', {':': 'disable'})

  call skkeleton#register_kanatable('azik', {"n'": ['ん']})
  call skkeleton#register_kanatable('azik', {"n:": ['ん']})
  call skkeleton#register_kanatable('azik', {"z\<Space>": ['　']})
  call skkeleton#register_kanatable('azik', {'l': ['っ']})
  call skkeleton#register_kanatable('azik', {'q': 'katakana'})

  " patched
  call skkeleton#register_kanatable('azik', {'byo': ['びょ']})

  call skkeleton#register_keymap('input', ';', 'henkanPoint')
endfunction
command! SKKAzik call s:azik()
call s:azik()

function! s:tsuki() abort
  lua require('vimrc.plug.skkeleton.tsuki2-263mod')()
  tabedit
  setlocal buftype=nofile bufhidden=hide noswapfile
  call setline(1, readfile(expand('$VIMDIR/lua/vimrc/plug/skkeleton/tsukimod.txt')))
  vsplit
endfunction
command! SKKTsuki call s:tsuki()

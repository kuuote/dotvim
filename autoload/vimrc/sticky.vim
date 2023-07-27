" original from https://github.com/Shougo/shougo-s-github/blob/626434dcca67927e98982657861c9cc4484177ec/vim/autoload/vimrc.vim#L5-L35
let s:register_table = {}
const s:sticky_table = {
      \  ',': '<', '.': '>', '/': '?',
      \  '1': '!', '2': '@', '3': '#', '4': '$', '5': '%',
      \  '6': '^', '7': '&', '8': '*', '9': '(', '0': ')',
      \  '-': '_', '=': '+',
      \  ';': ':', '[': '{', ']': '}', '`': '~', "'": "\"", '\': '|',
      \ }
const s:special_table = {
      \  "\<ESC>": "\<ESC>", "\<Tab>": ';', "\<CR>": ";\<CR>",
      \ }

function vimrc#sticky#register(from, to)
  let s:register_table[a:from] = a:to
endfunction

function vimrc#sticky#func() abort

  let char = ''

  while 1
    silent! let char = getchar()->nr2char()

    if char =~# '\l'
      let char = char->toupper()
      break
    elseif s:register_table->has_key(char)
      let char = s:register_table[char]
      break
    elseif s:sticky_table->has_key(char)
      let char = s:sticky_table[char]
      break
    elseif s:special_table->has_key(char)
      let char = s:special_table[char]
      break
    endif
  endwhile

  return char
endfunction

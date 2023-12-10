if has('nvim')
  let s:opts = #{relative: 'cursor', col: 0, row: 1, anchor: 'NW', style: 'minimal'}
else
  let s:opts = #{pos: 'botleft', line: 'cursor+1', col: 'cursor', highlight: 'WildMenu'}
endif

call skkeleton_state_popup#config(#{
  \   labels: {
  \     'input': #{hira: 'あ', kata: 'ア', hankata: 'ｶﾅ', zenkaku: 'Ａ'},
  \     'input:okurinasi': #{hira: '▽▽', kata: '▽▽', hankata: '▽▽', abbrev: 'ab'},
  \     'input:okuriari': #{hira: '▽▽', kata: '▽▽', hankata: '▽▽'},
  \     'henkan': #{hira: '▼▼', kata: '▼▼', hankata: '▼▼', abbrev: 'ab'},
  \   },
  \   opts: s:opts,
  \ })
call skkeleton_state_popup#run()

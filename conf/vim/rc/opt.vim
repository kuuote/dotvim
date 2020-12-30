" termguicolors有効化のためターミナルタイプの強制書き換え
" ちらつくので起動時のみ
if !v:vim_did_enter
  set term=xterm-256color
endif

" tmux上だとItalic表示が残念になるので無効化
if exists('$TMUX')
  set t_ZH=
endif

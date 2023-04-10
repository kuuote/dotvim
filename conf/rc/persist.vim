" persistent colorscheme
source `=$DOTVIM .. "/persist/persist.vim"`
if filereadable('/tmp/colors.vim')
  source /tmp/colors.vim
endif

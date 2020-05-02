if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading\ $*\ \\\|\ sort\ -t\ :\ -k\ 1,1\ -k\ 2,2n
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

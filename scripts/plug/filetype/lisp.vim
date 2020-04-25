call minpac#add('guns/vim-sexp', {'type': 'opt'})

" FIXME:filetype動かないのでは？
autocmd FileType clojure,lisp,scheme ++once packadd vim-sexp

let g:sexp_mappings = {}

" barfage
let g:sexp_mappings.sexp_emit_head_element = "<Leader>j"
let g:sexp_mappings.sexp_emit_tail_element = "<Leader>k"
" slurpage
let g:sexp_mappings.sexp_capture_next_element = "<Leader>l"
let g:sexp_mappings.sexp_capture_prev_element = "<Leader>h"

let g:sexp_enable_insert_mode_mappings = v:false

" /data/newvim/old/conf/plug/skkeleton.lua

let s:dicts = [
\   ['/data/vim/repos/github.com/skk-dev/dict/SKK-JISYO.L', 'utf-8'],
\ ]
call skkeleton#config(#{
\   eggLikeNewline: v:true,
\   markerHenkan: '',
\   markerHenkanSelect: '',
\   registerConvertResult: v:true,
\   showCandidatesCount: 1,
\   globalDictionaries: s:dicts,
\ })

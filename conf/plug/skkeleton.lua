local autocmd = require('vimrc.compat.autocmd')
local vimeval = require('vimrc.compat.convert').call

--+ 初期化

local function initialize()
  local dictPath = vimeval('dein#get', 'dict').path
  vimeval('skkeleton#config', {
    eggLikeNewline = true,
    globalDictionaries = {
      dictPath .. '/SKK-JISYO.L',
    },
    registerConvertResult = true,
    showCandidatesCount = 1,
    -- マーカーやめられることだしやめる
    markerHenkan = '',
    markerHenkanSelect = '',
  })
  -- USキーボードの n' で「ん」を打てるやつをJISキーボードでもやる
  vimeval('skkeleton#register_kanatable', 'rom', {
    ['n:'] = { 'ん', '' },
  })
end

initialize()
-- 2回目以降の呼び出しに備える
autocmd.define('User', {
  pattern = 'skkeleton-initialize-pre',
  callback = initialize,
})

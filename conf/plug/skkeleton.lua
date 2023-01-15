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

--+ virtual textでモード出すやつ
--  original code by @uga-rosa

local set
local reset
if is_nvim then
  local ns = vim.api.nvim_create_namespace('skkeleton')
  local id = 1234321
  local function line()
    return vim.fn.line('.') - 1
  end

  local function col()
    return vim.fn.col('.') - 1
  end

  set = function()
    vim.api.nvim_buf_set_extmark(0, ns, line(), col(), {
      id = id,
      virt_text = { { vim.fn['skkeleton#mode'](), 'PMenuSel' } },
      virt_text_pos = 'eol',
    })
  end
  reset = function()
    vim.api.nvim_buf_del_extmark(0, ns, id)
  end
else
  local fn = require('vimrc.compat.convert').fn
  local prop_type = 'skkeleton_show_mode'
  fn.prop_type_add(prop_type, {
    highlight = 'PMenuSel',
  })
  set = function()
    reset()
    fn.prop_add(fn.line('.'), 0, {
      type = prop_type,
      text = ' ' .. fn['skkeleton#mode'](),
      text_align = 'after',
    })
  end
  reset = function()
    fn.prop_remove { type = prop_type }
  end
end
autocmd.define('User', {
  pattern = 'skkeleton-enable-post',
  callback = function()
    autocmd.group('skkeleton-show-mode', { clear = true })
    autocmd.define('CursorMovedI', {
      pattern = '*',
      group = 'skkeleton-show-mode',
      callback = set,
    })
  end,
})
autocmd.define('User', {
  pattern = 'skkeleton-disable-post',
  callback = function()
    autocmd.group('skkeleton-show-mode', { clear = true })
    reset()
  end,
})

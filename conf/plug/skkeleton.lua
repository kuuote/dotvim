local autocmd = require('vimrc.compat.autocmd')
local vimx = require('artemis')
local vimeval = require('vimrc.compat.convert').call

--+ 初期化

local function initialize()
  local mydictPath = vimeval('dein#get', 'mydicts').path
  local dicts = vimx.fn.glob(mydictPath .. '/SKK-JISYO.*', 0, 1)
  local dictPath = vimeval('dein#get', 'dict').path
  dicts[#dicts + 1] = dictPath .. '/SKK-JISYO.L'
  vimeval('skkeleton#config', {
    eggLikeNewline = true,
    globalDictionaries = dicts,
    registerConvertResult = true,
    showCandidatesCount = 1,
    -- マーカーやめられることだしやめる
    markerHenkan = '',
    markerHenkanSelect = '',
  })
  -- USキーボードの n' で「ん」を打てるやつをJISキーボードでもやる
  vimeval('skkeleton#register_kanatable', 'rom', {
    ['n:'] = { 'ん', '' },
    ['xx'] = 'purgeCandidate',
  })
  -- from https://github.com/yasunori-kirin0418/dotfiles/blob/c586342802c1c43fb7b89b314bdd9d17b5f0c7f3/config/nvim/autoload/vimrc.vim
  vimeval('skkeleton#register_kanatable', 'rom', {
    ['z0'] = { '○', '' },
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

local function get_text()
  local state = vim.g['skkeleton#state']
  if state == nil then
    return ''
  end
  local text = ''
  if state.phase == 'input:okurinasi' then
    if vim.fn['skkeleton#mode']() == 'abbrev' then
      text = '/'
    else
      text = '>'
    end
  end
  if state.phase == 'input:okuriari' then
    text = '*'
  end
  if state.phase == 'henkan' then
    text = '<'
  end
  if text == '' then
    return vim.fn['skkeleton#mode']()
  end
  return text
end

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
      virt_text = { { get_text(), 'PMenuSel' } },
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
      text = ' ' .. get_text(),
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
    autocmd.define('User', {
      pattern = 'skkeleton-handled',
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

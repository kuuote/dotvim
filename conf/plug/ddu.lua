local act = vim.fn['ddu#custom#action']
local au = require('vimrc.compat.autocmd').define
local vimx = require('artemis')

local function config()
  if true then
    return
  end
  -- ui_ff
  act('ui', 'ff', 'inputAction', function(args)
    local item = vimx.fn['ddu#ui#get_item']()
    local actions = vimx.fn['ddu#get_item_actions'](args.options.name, { item })
    local opt = vimx.fn['ddc#custom#get_buffer']()
    vimx.fn['ddc#custom#set_buffer'] {
      cmdlineSources = { 'list' },
      sources = { 'list' },
      sourceOptions = {
        list = {
          minAutoCompleteLength = 0,
        },
      },
      sourceParams = {
        list = {
          candidates = actions,
        },
      },
    }
    local action = vim.fn.input('action:')
    vimx.fn['ddc#custom#set_buffer'](opt)
    for _, a in ipairs(actions) do
      if action == a then
        vimx.fn['ddu#ui#do_action']('itemAction', {
          name = action,
        })
        return
      end
    end
    print(('`%s`?知らない子ですねぇ'):format(action))
  end)
end

au('User', {
  pattern = 'DenopsPluginPost:ddu',
  callback = config,
})
config()

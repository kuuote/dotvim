local au = require('vimrc.autocmd').define
local convert = require('vimrc.convert').convert
local map = require('vimrc.map').define
local vimcall = require('vimrc.convert').call
local cmd = vim.cmd or vim.command

local customs = {}

local function change_source(name)
  local bufnr = vim.fn.bufnr()
  if customs[bufnr] == nil then
    customs[bufnr] = vimcall('ddc#custom#get_buffer')
  end
  vimcall('ddc#custom#set_buffer', {
    sources = { name },
  })
end

local function reset()
  local bufnr = vim.fn.bufnr()
  if customs[bufnr] ~= nil then
    vimcall('ddc#custom#set_buffer', customs[bufnr])
    customs[bufnr] = nil
  end
end

-- resetter
au('InsertLeave', { callback = reset })
map('i', '<C-x><C-x>', reset)

map('i', '<C-x><C-f>', function()
  change_source('file')
  local isk = vimcall('getbufvar', vimcall('bufnr'), '&iskeyword')
  cmd('set isk+=.')
  au('InsertLeave', {
    callback = function()
      vimcall('setbufvar', vimcall('bufnr'), '&iskeyword', isk)
    end
  })
end)

map('i', '<C-x><C-j>', function()
  change_source('suconv')
  vimcall('ddc#custom#patch_buffer', {
    sourceOptions = {
      suconv = {
        converters = {},
        matchers = {},
        sorters = {},
        isVolatile = true,
        maxItems = 20,
      }
    },
    specialBufferCompletion = true,
  })
end)

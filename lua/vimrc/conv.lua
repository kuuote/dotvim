-- base converter

if vim.fn.has('nvim') == 1 then
  local function id(...)
    return ...
  end
  return {
    empty_dict = vim.empty_dict,
    islist = vim.tbl_islist,
    vim = id,
    lua = id,
    call = vim.call,
  }
end

local M = {}

local empty_dict_mt = {}

function M.empty_dict()
  return setmetatable({}, empty_dict_mt)
end

function M.islist(tbl)
  if getmetatable(tbl) == empty_dict_mt then
    return false
  end
  local max = 0
  for k, v in pairs(tbl) do
    if type(k) ~= 'number' then
      return false
    end
    max = max < k and k or max
  end
  return #tbl == max
end

function M.vim(value)
  if type(value) == 'table' then
    local newtable = {}
    for k, v in pairs(value) do
      newtable[k] = M.vim(v)
    end
    if M.islist(newtable) then
      return vim.list(newtable)
    else
      return vim.dict(newtable)
    end
    return newtable
  end
  return value
end

function M.lua(value)
  local t = vim.type(value)
  if t == 'dict' then
    local tbl = {}
    for k, v in value() do
      tbl[k] = M.lua(v)
    end
    return tbl
  end
  if t == 'list' then
    local tbl = {}
    local count = 1
    for v in value() do
      tbl[count] = M.lua(v)
      count = count + 1
    end
    return tbl
  end
  if t == 'table' then
    local tbl = {}
    for k, v in pairs(value) do
      tbl[k] = M.lua(v)
    end
    return tbl
  end
  return value
end

-- various functions

function M.call(fn, ...)
  local tbl = {...}
  for k, v in pairs(tbl) do
    tbl[k] = M.vim(v)
  end
  return M.lua(vim.call(fn, unpack(tbl)))
end

-- M.call('map', {'foo', 'bar'}, print)

return M

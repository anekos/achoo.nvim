local M = {}

local Percent = require('achoo.lib.percent')
local Lua = require('achoo.lib.lua')

M.registered = {}

local function make_session(session_type, keys)
  return { type = session_type, keys = keys }
end

function M.register(session_type, opts)
  if M.registered[session_type] ~= nil then
    error('Session type already registered: ' .. session_type)
  end

  M.registered[session_type] = opts

  -- TODO assertion for type
  if not opts.make_keys and not opts.auto_keys then
    error('Not implemented: make_keys or auto_keys')
  end

  if not opts.make_keys then
    opts.make_keys = function(callback)
      callback(opts.auto_keys())
    end
  end

  if not opts.to_display then
    opts.to_display = function(...)
      local args = { ... }
      return vim.fn.join(args, ' 〰️ ')
    end
  end
end

function M.make(session_type, keys)
  local st = M.registered[session_type]

  if st == nil then
    error('Unknown session type: ' .. session_type)
  end

  if keys then
    return make_session(session_type, keys)
  end

  local auto_keys = st.auto_keys

  if not auto_keys then
    return nil
  end

  return make_session(session_type, auto_keys())
end

function M.make_async(session_type, callback)
  local st = M.registered[session_type]

  if st == nil then
    error('Unknown session type: ' .. session_type)
  end

  st.make_keys(function(keys)
    callback(make_session(session_type, keys))
  end)
end

function M.from_filename(filename)
  if filename:match('%.vim$') == nil then
    error('Invalid filename')
  end

  local no_ext = vim.fn.fnamemodify(filename, ':r')
  local session_type, keys = unpack(Lua.split(no_ext, '/', 2))
  keys = Lua.map(Percent.decode)(vim.split(keys, '/'))

  if M.registered[session_type] == nil then
    error('Unknown session type: ' .. session_type)
  end

  return make_session(session_type, keys)
end

function M.to_filename(session)
  return session.type .. '/' .. vim.fn.join(Lua.map(Percent.encode)(session.keys), '/') .. '.vim'
end

function M.to_display(session)
  if M.registered[session.type] == nil then
    error('Unknown session type: ' .. session.type)
  end

  return session.type .. ': ' .. M.registered[session.type].to_display(unpack(session.keys))
end

function M.types()
  local result = {}
  for session_type, _ in pairs(M.registered) do
    table.insert(result, session_type)
  end
  return result
end

return M

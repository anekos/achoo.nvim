local M = {}

local Percent = require('achoo.lib.percent')
local Lua = require('achoo.lib.lua')

M.registered = {}

local function identity(x)
  return x
end

local function make_session(session_type, key)
  return { type = session_type, key = key }
end

function M.register(session_type, opts)
  if M.registered[session_type] ~= nil then
    error('Session type already registered: ' .. session_type)
  end

  M.registered[session_type] = opts

  -- TODO assertion for type
  if not opts.make_key and not opts.auto_key then
    error('Not implemented: make_key or auto_key')
  end

  if not opts.make_key then
    opts.make_key = function(callback)
      callback(opts.auto_key())
    end
  end

  if opts.to_code == nil then
    opts.to_code = identity
  end
  if opts.from_code == nil then
    opts.from_code = identity
  end

  if not opts.to_display then
    opts.to_display = opts.to_code
  end
end

function M.make(session_type, key)
  local st = M.registered[session_type]

  if st == nil then
    error('Unknown session type: ' .. session_type)
  end

  if key then
    return make_session(session_type, key)
  end

  local auto_key = st.auto_key

  if not auto_key then
    return nil
  end

  return make_session(session_type, auto_key())
end

function M.make_async(session_type, key, callback)
  local st = M.registered[session_type]

  if st == nil then
    error('Unknown session type: ' .. session_type)
  end

  if key then
    callback(make_session(session_type, key))
    return
  end

  st.make_key(function(k)
    callback(make_session(session_type, k))
  end)
end

function M.from_filename(filename)
  if filename:match('%.vim$') == nil then
    error('Invalid filename')
  end

  local no_ext = vim.fn.fnamemodify(filename, ':r')
  local session_type, key = unpack(Lua.split(no_ext, '/', 2))
  key = Percent.decode(key)

  if M.registered[session_type] == nil then
    error('Unknown session type: ' .. session_type)
  end

  return make_session(session_type, key)
end

function M.to_filename(session)
  return session.type .. '/' .. Percent.encode(session.key) .. '.vim'
end

function M.to_code(session)
  if M.registered[session.type] == nil then
    error('Unknown session type: ' .. session.type)
  end

  return session.type .. ':' .. M.registered[session.type].to_code(session.key)
end

function M.to_display(session)
  if M.registered[session.type] == nil then
    error('Unknown session type: ' .. session.type)
  end

  return session.type .. ': ' .. M.registered[session.type].to_display(session.key)
end

function M.from_code(text)
  local session_type, key = unpack(Lua.split(text, ':', 2))

  if key == nil or session_type == nil then
    error('Invalid session code')
  end

  return make_session(session_type, M.registered[session_type].from_code(key))
end

function M.types()
  local result = {}
  for session_type, _ in pairs(M.registered) do
    table.insert(result, session_type)
  end
  return result
end

return M

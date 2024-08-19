local M = {}

local Percent = require('achoo.lib.percent')

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

  if opts.auto_key ~= nil then
    opts.make_key = function(args, callback)
      if args == nil then
        opts.auto_key(function(key)
          callback(key)
        end)
        return
      end
      error('Too many arguments')
    end
  end

  -- TODO assertion for type

  if opts.to_code == nil then
    opts.to_code = identity
  end
  if opts.from_code == nil then
    opts.from_code = identity
  end
end

function M.make(session_type, key, callback)
  if M.registered[session_type] == nil then
    error('Unknown session type: ' .. session_type)
  end

  if key == nil then
    M.registered[session_type].make_key(nil, function(k)
      callback(make_session(session_type, k))
    end)
    return
  end

  callback(make_session(session_type, key))
end

function M.from_filename(filename)
  if filename:match('%.vim$') == nil then
    error('Invalid filename')
  end

  local no_ext = vim.fn.fnamemodify(filename, ':r')
  local session_type, key = unpack(vim.split(no_ext, '/'))
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

M.to_display = M.to_code

function M.from_code(text)
  local session_type, key = unpack(vim.split(text, ':', { trimempty = true }))

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

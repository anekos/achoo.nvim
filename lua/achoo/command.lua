local M = {}

local Fs = require('achoo.fs')
local Session = require('achoo.session')
local State = require('achoo.state')
local Ui = require('achoo.ui')

function M.delete(args, force)
  args = vim.trim(args)
  if args == '' then
    args = nil
  end

  if args ~= nil then
    local session = Session.from_code(args)
    if force then
      Fs.delete_session(session)
      return
    end
    Ui.confirm('Delete session: ' .. Session.to_display(session), function()
      Fs.delete_session(session)
    end)
    return
  end

  vim.ui.select(M.complete_sessions(), { prompt = 'Select session' }, function(answer)
    if answer == nil or answer == '' then
      return
    end
    M.delete(answer, force)
  end)
end

function M.load(args)
  args = vim.trim(args)
  if args == '' then
    args = nil
  end

  if args ~= nil then
    Fs.load_session(Session.from_code(args))
    return
  end

  vim.ui.select(M.complete_sessions(), { prompt = 'Select session' }, function(answer)
    if answer == nil or answer == '' then
      return
    end
    M.load(answer)
  end)
end

function M.save(args, overwrite)
  args = vim.trim(args)

  local session_type, key = unpack(vim.split(args, ' ', { trimempty = true }))

  if session_type == nil then
    vim.ui.select(Session.types(), { prompt = 'Session type' }, function(answer)
      if answer == nil or answer == '' then
        return
      end
      M.save(answer, overwrite)
    end)
    return
  end

  Session.make(session_type, key, function (session)
    Fs.save_session(session, overwrite)
  end)
end

function M.set_auto_save(args)
  if args == '' then
    State.auto_save = not State.auto_save
  elseif args == 'on' then
    State.auto_save = true
  elseif args == 'off' then
    State.auto_save = false
  else
    error('Invalid argument')
  end
  vim.notify('Auto save is ' .. (State.auto_save and 'enabled' or 'disabled'))
end

function M.complete_sessions()
  local result = {}
  for _, session in ipairs(Fs.sessions()) do
    table.insert(result, Session.to_code(session))
  end
  return result
end

function M.complete_types()
  return Session.types()
end

return M

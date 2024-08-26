local M = {}

local Fs = require('achoo.fs')
local Session = require('achoo.session')
local State = require('achoo.state')
local Ui = require('achoo.ui')
local Lua = require('achoo.lib.lua')

PromptOptions = { prompt = 'Select session', format_item = Session.to_display }

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
  end

  vim.ui.select(Fs.sessions(), PromptOptions, function(session)
    if session then
      Ui.confirm('Delete session: ' .. Session.to_display(session), function()
        Fs.delete_session(session)
      end)
    end
  end)
end

function M.unsafe_load(args)
  args = vim.trim(args)
  if args == '' then
    args = nil
  end

  if args ~= nil then
    Fs.load_session(Session.from_code(args))
    return
  end

  vim.ui.select(Fs.sessions(), PromptOptions, function(session)
    if session then
      Fs.load_session(session)
    end
  end)
end

function M.load(args)
  local ok, msg = pcall(M.unsafe_load, args)
  if not ok and State.auto_save then
    msg = vim.split(msg, '\n')
    table.insert(msg, 1, 'Failed to load session, auto save is disabled.')
    vim.notify(msg)
    State.auto_save = false
  end
end

function M.save(args, overwrite)
  local function do_save(session)
    if overwrite or not Fs.session_exists(session) then
      Fs.save_session(session, overwrite)
    else
      Ui.confirm('Session already exists, overwrite?', function()
        Fs.save_session(session, true)
      end)
    end
  end

  args = vim.trim(args)

  local session_type, key = unpack(Lua.split(args, ' ', 2))

  if session_type == nil then
    vim.ui.select(Session.types(), { prompt = 'Session type' }, function(answer)
      if answer then
        M.save(answer, overwrite)
      end
    end)

    return
  end

  Session.make_async(session_type, key, function(session)
    if session then
      do_save(session)
    end
  end)
end

function M.update()
  if State.last_session == nil then
    vim.notify('No session loaded')

    return
  end

  Fs.save_session(State.last_session, true)
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
  table.sort(result)
  return result
end

function M.complete_types()
  return Session.types()
end

return M

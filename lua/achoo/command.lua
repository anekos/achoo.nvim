local Fs = require('achoo.fs')
local Session = require('achoo.session')
local State = require('achoo.state')
local Types = require('achoo.types')
local Ui = require('achoo.ui')

local M = {}

PromptOptions = { prompt = 'Select session', format_item = Session.to_display }

local function get_sessions(contextual)
  local all_sessions = Fs.sessions()

  if not contextual then
    return all_sessions
  end

  local result = {}

  for name, t in pairs(Types) do
    if t.auto_keys then
      local ok, keys = pcall(t.auto_keys)
      local made = Session.make(name, keys)
      if ok then
        vim.list_extend(
          result,
          vim.tbl_filter(function(s)
            return vim.deep_equal(s, made)
          end, all_sessions)
        )
      end
    end
  end

  return result
end

function M.delete(force)
  vim.ui.select(Fs.sessions(), PromptOptions, function(session)
    if not session then
      return
    end

    if force then
      Fs.delete_session(session)
      return
    end

    Ui.confirm('Delete session: ' .. Session.to_display(session), function()
      Fs.delete_session(session)
    end)
  end)
end

function M.load(contextual)
  local function do_load()
    Ui.select(get_sessions(contextual), PromptOptions, function(session)
      if session then
        Fs.load_session(session)
      end
    end)
  end

  local ok, msg = pcall(do_load)
  if not ok and State.auto_save then
    State.auto_save = false
    print(msg)
    print(debug.traceback())
    vim.notify('Failed to load session, auto save is disabled.')
  end
end

function M.save(overwrite)
  local function do_save(session)
    if overwrite or not Fs.session_exists(session) then
      Fs.save_session(session, overwrite)
    else
      Ui.confirm('Session already exists, overwrite?', function()
        Fs.save_session(session, true)
      end)
    end
  end

  vim.ui.select(Session.types(), { prompt = 'Session type' }, function(session_type)
    if not session_type then
      return
    end

    Session.make_async(session_type, function(session)
      if session then
        do_save(session)
      end
    end)
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

function M.complete_types()
  return Session.types()
end

return M

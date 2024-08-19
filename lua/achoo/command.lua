local M = {}

local Fs = require('achoo.fs')
local Meta = require('achoo.meta')
local State = require('achoo.state')

function M.load(args)
  args = vim.trim(args)

  if 0 < #args then
    Fs.load_session(Meta.from_text(args))
    return
  end

  vim.ui.select(M.complete_sessions(), { prompt = 'Select session' }, function(answer)
    if answer == nil or answer == '' then
      return
    end
    Fs.load_session(Meta.from_text(answer))
  end)
end

function M.save(args, overwrite)
  args = vim.trim(args)

  local first, second = unpack(vim.split(args, ' ', { trimempty = true }))

  if first == nil then
    vim.ui.select(Meta.bases, { prompt = 'Session type' }, function(answer)
      if answer == nil or answer == '' then
        return
      end
      M.save(answer, overwrite)
    end)
    return
  end

  if first == 'name' then
    if second == nil then
      vim.ui.input({ prompt = 'Session name' }, function(answer)
        if answer == nil or answer == '' then
          return
        end
        Fs.save_session(Meta.named_session(answer), overwrite)
      end)
      return
    end

    Fs.save_session(Meta.named_session(second), overwrite)
    return
  end

  if first == 'directory' then
    if second == nil then
      Fs.save_session(Meta.directory_session(vim.fn.getcwd()), overwrite)
      return
    end

    error('Too many arguments')
  end

  error('Unknown session type')
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
  for _, meta in ipairs(Fs.sessions()) do
    table.insert(result, Meta.to_text(meta))
  end
  return result
end

function M.complete_bases()
  return Meta.bases
end

return M

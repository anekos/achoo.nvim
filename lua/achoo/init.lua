local Cmd = require('achoo.command')
local Fs = require('achoo.fs')
local Session = require('achoo.session')
local State = require('achoo.state')
local Types = require('achoo.types')
local Ui = require('achoo.ui')

local M = {}

local function register_sources()
  for session_type, definition in pairs(Types) do
    Session.register(session_type, definition)
  end
end

local function define_command()
  vim.api.nvim_create_user_command('AchooSave', function(opts)
    Cmd.save(opts.bang)
  end, {
    nargs = 0,
    bang = true,
  })

  vim.api.nvim_create_user_command('AchooUpdate', function()
    Cmd.update()
  end, {
    nargs = 0,
  })

  vim.api.nvim_create_user_command('AchooLoad', function(opts)
    Cmd.load(opts.bang)
  end, {
    nargs = 0,
    bang = true,
  })

  vim.api.nvim_create_user_command('AchooAutoSave', function(opts)
    Cmd.set_auto_save(opts.args)
  end, {
    nargs = '?',
    complete = function(_, _, _)
      return { 'on', 'off' }
    end,
  })

  vim.api.nvim_create_user_command('AchooEdit', function()
    Cmd.edit()
  end, {
    nargs = 0,
  })

  vim.api.nvim_create_user_command('AchooDelete', function(opts)
    Cmd.delete(opts.bang)
  end, {
    nargs = 0,
    bang = true,
  })

  vim.api.nvim_create_user_command('AchooTest', function(opts)
      Fs.rotate(State.session_rotation_prefix, State.session_rotation_limit)
  end, {
    nargs = 0,
    bang = true,
  })
end

local function define_auto_commands()
  vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    pattern = { '*' },
    callback = function()
      if State.last_session == nil or not State.auto_save then
        if State.session_rotation then
          Fs.rotate(State.session_rotation_prefix, State.session_rotation_limit)
        end
        return
      end
      if State.confirm_on_leave then
        Ui.confirm('Save last session?', function()
          Fs.save_session(State.last_session, true, true)
        end)
      else
        Fs.save_session(State.last_session, true, true)
      end
    end,
  })
end

local function apply_config(opts)
  local function apply(name)
    if opts[name] ~= nil then
      State[name] = opts[name]
    end
  end

  apply('auto_save')
  apply('confirm_on_leave')
  apply('icon')
  apply('preprocess')
  apply('session_rotation')
  apply('session_rotation_prefix')
  apply('seeion_rotation_limit')
end

function M.setup(opts)
  register_sources()
  apply_config(opts)
  define_command()
  define_auto_commands()
end

return M

local M = {}

local Cmd = require('achoo.command')
local State = require('achoo.state')
local Fs = require('achoo.fs')
local Session = require('achoo.session')
local Types = require('achoo.types')
local Ui = require('achoo.ui')

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

  vim.api.nvim_create_user_command('AchooLoad', function(_)
    Cmd.load()
  end, {
    nargs = 0,
  })

  vim.api.nvim_create_user_command('AchooAutoSave', function(opts)
    Cmd.set_auto_save(opts.args)
  end, {
    nargs = '?',
    complete = function(_, _, _)
      return { 'on', 'off' }
    end,
  })

  vim.api.nvim_create_user_command('AchooDelete', function(opts)
    Cmd.delete(opts.bang)
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
        return
      end
      if State.confirm_on_leave then
        Ui.confirm('Save last session?', function()
          Fs.save_session(State.last_session, true)
        end)
      else
        Fs.save_session(State.last_session, true)
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
end

function M.setup(opts)
  register_sources()
  apply_config(opts)
  define_command()
  define_auto_commands()
end

return M

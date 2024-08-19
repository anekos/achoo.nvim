local M = {}

local Cmd = require('achoo.command')
local State = require('achoo.state')
local Fs = require('achoo.fs')
local Session = require('achoo.session')
local Types = require('achoo.types')

local function register_sources()
  for session_type, definition in pairs(Types) do
    Session.register(session_type, definition)
  end
end

local function define_command()
  vim.api.nvim_create_user_command('AchooSave', function(opts)
    Cmd.save(opts.args, opts.bang)
  end, {
    nargs = '*',
    bang = true,
    complete = Cmd.complete_types,
  })

  vim.api.nvim_create_user_command('AchooLoad', function(opts)
    Cmd.load(opts.args)
  end, {
    nargs = '*',
    complete = Cmd.complete_sessions,
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
    Cmd.delete(opts.args, opts.bang)
  end, {
    nargs = '*',
    bang = true,
    complete = Cmd.complete_sessions,
  })
end

local function define_auto_commands()
  vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    pattern = { '*' },
    callback = function()
      if State.last_session == nil then
        return
      end
      Fs.save_session(State.last_session, true)
    end,
  })
end

local function apply_config(opts)
  if opts.auto_save ~= nil then
    State.auto_save = opts.auto_save
  end
end

function M.setup(opts)
  register_sources()
  apply_config(opts)
  define_command()
  define_auto_commands()
end

return M

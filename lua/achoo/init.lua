local M = {}

function M.setup(_)
  local Cmd = require('achoo.command')

  vim.api.nvim_create_user_command('AchooSave', function(opts)
    Cmd.save(opts.args, opts.bang)
  end, {
    nargs = '*',
    bang = true,
    complete = Cmd.complete_bases,
  })

  vim.api.nvim_create_user_command('AchooLoad', function(opts)
    Cmd.load(opts.args)
  end, {
    nargs = '*',
    complete = Cmd.complete_sessions,
  })
end

return M

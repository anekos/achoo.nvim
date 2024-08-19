local M = {}

function M.setup(_)
  local Cmd = require('achoo.command')

  vim.api.nvim_create_user_command('AchooSave', function(opts)
    if 0 < #opts.args then
      Cmd.save(opts.args)
      return
    end

    vim.ui.input({ prompt = 'Session name' }, function(answer)
      Cmd.save('name:' .. answer)
    end)
  end, {
    nargs = '*',
    complete = Cmd.complete_sessions,
  })

  vim.api.nvim_create_user_command('AchooLoad', function(opts)
    Cmd.load(opts.args)
  end, {
    nargs = '*',
    complete = Cmd.complete_sessions,
  })
end

return M

local M = {}

function M.setup(_)
  local Cmd = require('achoo.command')

  vim.api.nvim_create_user_command('AchooSave', function(opts)
    if 0 < #opts.args then
      Cmd.save(opts.args)
      return
    end

    vim.ui.input({ prompt = 'Session name' }, function(answer)
      if answer == nil or answer == '' then
        return
      end
      Cmd.save('name:' .. answer)
    end)
  end, {
    nargs = '*',
    complete = Cmd.complete_sessions,
  })

  vim.api.nvim_create_user_command('AchooLoad', function(opts)
    if 0 < #opts.args then
      Cmd.load(opts.args)
    end

    vim.ui.select(Cmd.complete_sessions(), { prompt = 'Select session' }, function(answer)
      if answer == nil or answer == '' then
        return
      end
      Cmd.load(answer)
    end)
  end, {
    nargs = '*',
    complete = Cmd.complete_sessions,
  })
end

return M

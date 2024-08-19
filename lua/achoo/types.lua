local M = {}

M.name = {
  make_key = function(args, callback)
    if args == nil then
      vim.ui.input({ prompt = 'Session name' }, function(answer)
        if answer == nil or answer == '' then
          return
        end
        callback(answer)
      end)
      return
    end

    callback(args)
  end,
}

M.directory = {
  make_key = function(args, callback)
    if args == nil then
      callback(vim.fn.getcwd())
      return
    end

    error('Too many arguments')
  end,

  to_code = function(key)
    return vim.fn.fnamemodify(key, ':~')
  end,

  from_code = function(code)
    return vim.fn.expand(code)
  end,
}

return M

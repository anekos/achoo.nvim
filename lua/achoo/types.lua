local M = {}

local Git = require('achoo.lib.git')
local Lua = require('achoo.lib.lua')

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
  auto_key = function(callback)
    callback(vim.fn.getcwd())
  end,

  to_code = function(key)
    return vim.fn.fnamemodify(key, ':~')
  end,

  from_code = function(code)
    return vim.fn.expand(code)
  end,
}

M.branch = {
  auto_key = function(callback)
    local key = Git.repository_path() .. '@' .. Git.current_branch()
    callback(key)
  end,

  to_code = function(key)
    local path, branch = unpack(Lua.split(key, '@', 2))
    return vim.fn.fnamemodify(path, ':~') .. '@' .. branch
  end,

  from_code = function(code)
    local path, branch = unpack(Lua.split(code, '@', 2))
    return vim.fn.expand(path) .. '@' .. branch
  end,
}

return M

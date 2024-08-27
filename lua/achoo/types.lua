local M = {}

local Git = require('achoo.lib.git')
local Path = require('achoo.lib.path')
local State = require('achoo.state')

M.name = {
  make_keys = function(callback)
    vim.ui.input({ prompt = 'Session name' }, function(answer)
      if answer == nil or answer == '' then
        return
      end
      callback { answer }
    end)
  end,
}

M.directory = {
  auto_keys = function()
    return vim.fn.getcwd()
  end,

  to_display = Path.shrink,
}

M.repositry = {
  auto_keys = function()
    return { Git.repository_path() }
  end,

  to_display = Path.shrink,
}

M.branch = {
  auto_keys = function()
    return { Git.repository_path(), Git.current_branch() }
  end,

  to_display = function(repo, branch)
    return Path.shrink(repo) .. State.icon.branch .. branch
  end,
}

M.monorepo = {
  auto_keys = function()
    local repo = Git.repository_path()
    local path = Path.relative_path(vim.fn.getcwd(), repo)
    local branch = Git.current_branch()
    return { repo, path, branch }
  end,

  to_display = function(repo, path, branch)
    return Path.shrink(repo) .. State.icon.path .. path .. State.icon.branch .. branch
  end,
}

return M

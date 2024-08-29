local M = {}

local function clean(s)
  s = vim.fn.trim(s)
  if s == '' then
    return nil
  end
  return s
end

local function git(args, repo)
  local cmd = [[ git ]]
  if repo then
    cmd = cmd .. [[ -C ]] .. repo
  end
  cmd = cmd .. [[ ]] .. args
  local out = vim.fn.system(cmd)
  return vim.v.shell_error == 0, out
end

function M.repository_path(repo)
  local ok, path = git([[ rev-parse --show-toplevel 2>/dev/null ]], repo)
  if not ok then
    error('Failed to get repository path')
  end
  return clean(path)
end

function M.checkout(branch, repo)
  local ok, _ = git([[ checkout ]] .. branch, repo)
  if not ok then
    error('Failed to checkout branch: ' .. branch)
  end
end

function M.current_branch(repo)
  local ok, path = git([[ rev-parse --abbrev-ref HEAD 2>/dev/null ]], repo)
  if not ok then
    error('Failed to get current branch')
  end
  return clean(path)
end

return M

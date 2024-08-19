local M = {}

local function clean(s)
  s = vim.fn.trim(s)
  if s == '' then
    return nil
  end
  return s
end

function M.repository_path()
  return clean(vim.fn.system([[ git rev-parse --show-toplevel 2>/dev/null ]]))
end

function M.current_branch()
  return clean(vim.fn.system([[ git rev-parse --abbrev-ref HEAD 2>/dev/null ]]))
end

return M

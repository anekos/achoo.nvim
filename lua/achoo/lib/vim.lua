local M = {}

function M.command_line_escape(s)
  local result = s:gsub('%%', [[\%%]])
  return result
end

return M

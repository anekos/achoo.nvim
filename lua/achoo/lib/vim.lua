local M = {}

function M.command_line_escape(s)
  local result = s:gsub('%%', [[\%%]])
  return result
end

function M.modified()
  if 1 < vim.fn.bufnr() then
    return true
  end

  if vim.bo.modified then
    return true
  end

  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value('modified', { buffer = b }) then
      return true
    end
  end

  return false
end

return M

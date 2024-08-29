local M = {}

local badd_prefix = 'badd +'

function M.process(lines, validator)
  local result = {}
  for _, line in ipairs(lines) do
    if vim.startswith(line, badd_prefix) then
      local buffer_number = tonumber(string.sub(line, #badd_prefix + 1))
      if not validator(buffer_number) then
        goto continue
      end
    end

    table.insert(result, line)
    ::continue::
  end
  return result
end

function M.process_file(filepath, validator)
  local lines = vim.fn.readfile(filepath)
  lines = M.process(lines, validator)
  vim.fn.writefile(lines, filepath)
end

return M

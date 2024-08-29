local M = {}

function M.preprocess(validator)
  for _, buffer in ipairs(vim.fn.getbufinfo()) do
    if not validator(buffer.bufnr) then
      vim.cmd('bdelete ' .. buffer.bufnr)
    end
  end
end

return M

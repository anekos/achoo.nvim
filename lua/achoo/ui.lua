local M = {}

function M.confirm(prompt, callback)
  local res = vim.fn.confirm(prompt, '&Yes\n&No', 3)
  if res == 1 then
    callback()
  end
end

return M

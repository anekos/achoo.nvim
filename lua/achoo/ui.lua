local M = {}

function M.confirm(prompt, callback)
  local res = vim.fn.confirm(prompt, '&Yes\n&No', 3)
  if res == 1 then
    callback()
  end
end

function M.select(candidates, options, on_select)
  if #candidates == 0 then
    return
  end

  if #candidates == 1 then
    on_select(candidates[1])
    return
  end

  vim.ui.select(candidates, options, on_select)
end

return M

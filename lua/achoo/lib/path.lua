local M = {}

function M.relative_path(target, base)
  local abs_target = vim.fn.resolve(target)
  local abs_base = vim.fn.resolve(base)

  if abs_target == abs_base then
    return '.'
  end

  if #abs_target < #abs_base then
    return abs_target
  end

  if vim.startswith(abs_target, abs_base) then
    return abs_target:sub(#abs_base + 2)
  end
end

function M.shrink(path)
  return vim.fn.fnamemodify(path, ':~')
end

return M

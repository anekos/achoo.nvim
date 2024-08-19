local M = {}

local function keys(t)
  local result = 0
  for _ in pairs(t) do
    result = result + 1
  end
  return result
end

function M.equals(x, y)
  -- This function does not support cyclic references.

  if type(x) ~= 'table' or type(y) ~= 'table' then
    return x == y
  end

  if keys(x) ~= keys(y) then
    return false
  end

  for k, v in pairs(x) do
    if not M.equals(v, y[k]) then
      return false
    end
  end

  return true
end

-- local table1 = { a = 1, b = { c = 2, d = 3 } }
-- local table2 = { a = 1, b = { c = 2, d = 3 } }
-- local table3 = { a = 1, b = { c = 2, d = 4 } }
--
-- print(M.equals(table1, table2)) -- true
-- print(M.equals(table1, table3)) -- false

return M

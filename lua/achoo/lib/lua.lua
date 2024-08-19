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

function M.split(s, separator, limit)
  local result = {}
  local n = 0
  local right = 1

  for pos in
    function()
      return string.find(s, separator, right)
    end
  do
    n = n + 1
    if limit and n >= limit then
      result[n] = s:sub(right)
      return result
    else
      table.insert(result, s:sub(right, pos - 1))
      right = pos + 1
    end
  end

  if right <= #s then
    table.insert(result, s:sub(right))
  end

  return result
end

-- print(vim.inspect(M.split('one,two,three,four,five', ',', 3)))
-- print(vim.inspect(M.split('one,two,three', ',', 3)))
-- print(vim.inspect(M.split('one,two,', ',', 2)))
-- print(vim.inspect(M.split('one,two', ',', 2)))

-- local table1 = { a = 1, b = { c = 2, d = 3 } }
-- local table2 = { a = 1, b = { c = 2, d = 3 } }
-- local table3 = { a = 1, b = { c = 2, d = 4 } }
--
-- print(M.equals(table1, table2)) -- true
-- print(M.equals(table1, table3)) -- false

return M

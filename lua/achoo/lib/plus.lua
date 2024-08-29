local M = {}

function M.encode(s)
  local result = s:gsub('[^%w%-_~]', function(char)
    return string.format('+%02X', string.byte(char))
  end)
  return result
end

function M.decode(str)
  local result = str:gsub('+(%x%x)', function(hex)
    return string.char(tonumber(hex, 16))
  end)
  return result
end

return M

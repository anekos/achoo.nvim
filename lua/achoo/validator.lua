local M = {}

local function is_valid_buffer_type(buffer)
  local allows = { '', 'help' , 'terminal' }
  -- local denies = { 'acwrite', 'nofile', 'nowrite', 'prompt' , 'quickfix' }
  local buffer_type = vim.fn.getbufvar(buffer.bufnr, '&buftype')
  return vim.tbl_contains(allows, buffer_type)
end

local function is_valid_buffer(buffer)
  return is_valid_buffer_type(buffer)
end

function M.make_validator()
  local valid_buffers = {}

  for _, buffer in ipairs(vim.fn.getbufinfo()) do
    if is_valid_buffer(buffer) then
      valid_buffers[buffer.bufnr] = true
    end
  end

  return function(buffer_number)
    return valid_buffers[buffer_number]
  end
end

return M

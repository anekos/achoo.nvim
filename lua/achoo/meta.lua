local M = {}

function M.named_session(name)
  return {
    base = 'name',
    name = name,
  }
end

function M.from_filename(filename)
  if filename:match('%.vim$') == nil then
    error('Invalid filename')
  end

  local no_ext = vim.fn.fnamemodify(filename, ':r')
  local base, first = unpack(vim.split(no_ext, '/'))

  if base == 'name' then
    return M.named_session(first)
  end

  error('Unknown session type')
end

function M.to_filename(meta)
  if meta.base == 'name' then
    return 'name/' .. meta.name .. '.vim'
  end
  error('Unknown session type')
end

function M.to_text(meta)
  if meta.base == 'name' then
    return 'name:' .. meta.name
  end
  error('Unknown session type')
end

function M.from_text(text)
  local base, something = unpack(vim.split(text, ':', { trimempty = true }))

  if something == nil then
    error('Not enough arguments')
  end

  if base == 'name' then
    return M.named_session(something)
  end

  error('Unknown session type')
end

return M

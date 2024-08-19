local M = {}

local Percent = require('achoo.lib.percent')

M.bases = { 'name', 'directory' }

function M.named_session(name)
  return {
    base = 'name',
    name = name,
  }
end

function M.directory_session(path)
  return {
    base = 'directory',
    path = vim.fn.expand(path),
  }
end

function M.from_filename(filename)
  if filename:match('%.vim$') == nil then
    error('Invalid filename')
  end

  local no_ext = vim.fn.fnamemodify(filename, ':r')
  local base, first = unpack(vim.split(no_ext, '/'))
  first = Percent.decode(first)

  if base == 'name' then
    return M.named_session(first)
  elseif base == 'directory' then
    return M.directory_session(first)
  end

  error('Unknown session type')
end

function M.to_filename(meta)
  if meta.base == 'name' then
    return 'name/' .. Percent.encode(meta.name) .. '.vim'
  elseif meta.base == 'directory' then
    return 'directory/' .. Percent.encode(meta.path) .. '.vim'
  end
  error('Unknown session type')
end

function M.to_text(meta)
  if meta.base == 'name' then
    return 'name:' .. meta.name
  elseif meta.base == 'directory' then
    return 'directory:' .. vim.fn.fnamemodify(meta.path, ':~')
  end
  error('Unknown session type')
end

M.to_display = M.to_text

function M.from_text(text)
  local base, something = unpack(vim.split(text, ':', { trimempty = true }))

  if something == nil then
    error('Not enough arguments')
  end

  if base == 'name' then
    return M.named_session(something)
  elseif base == 'directory' then
    return M.directory_session(something)
  end

  error('Unknown session type')
end

return M

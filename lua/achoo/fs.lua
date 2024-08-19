local M = {}

local Path = require('plenary.path')
local Meta = require('achoo.meta')
local Vim = require('achoo.lib.vim')

local function get_base_directory()
  return Path:new(vim.fn.stdpath('data'), 'achoo', 'session')
end

local function make_filepath(meta)
  local dir = get_base_directory()
  return Path:new(dir, Meta.to_filename(meta))
end

function M.save_session(meta, overwrite)
  local session_file = make_filepath(meta)

  if not overwrite and session_file:exists() then
    vim.notify('Session already exists', 'error')
    return
  end

  session_file:parent():mkdir { parents = true }
  vim.cmd { cmd = 'mksession', args = { Vim.command_line_escape(session_file.filename) }, bang = true }

  vim.notify('Session saved: ' .. session_file.filename, 'info')
end

function M.load_session(meta)
  local session_file = make_filepath(meta)
  if not session_file:exists() then
    vim.notify('Session not found: ' .. session_file.filename, 'error')
    return
  end

  vim.cmd { cmd = 'source', args = { session_file.filename } }
  vim.notify('Session loaded: ' .. session_file.filename, 'info')
end

function M.sessions()
  local dir = get_base_directory()

  local meta_files = vim.fs.find(function(name)
    return name:match('.*%.vim$')
  end, { type = 'file', path = dir.filename, limit = 10 })

  local result = {}
  for _, mf in ipairs(meta_files) do
    local filename = Path:new(mf):make_relative(dir.filename)
    table.insert(result, Meta.from_filename(filename))
  end

  return result
end

return M

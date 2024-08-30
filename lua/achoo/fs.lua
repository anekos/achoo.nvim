local Path = require('plenary.path')
local Preprocess = require('achoo.preprocess')
local Session = require('achoo.session')
local State = require('achoo.state')
local Validator = require('achoo.validator')
local Vim = require('achoo.lib.vim')

local M = {}

local function get_base_directory()
  return Path:new(vim.fn.stdpath('data'), 'achoo', 'session')
end

local function make_filepath(session)
  local dir = get_base_directory()
  return Path:new(dir, Session.to_filename(session))
end

function M.session_exists(session)
  local session_file = make_filepath(session)
  return vim.fn.filereadable(session_file.filename) == 1
end

function M.save_session(session, overwrite, on_leave)
  local session_file = make_filepath(session)

  if not overwrite and session_file:exists() then
    vim.notify('Session already exists: ' .. Session.to_display(session), 'error')
    return
  end

  if State.preprocess and on_leave then
    local validator = Validator.make_validator()
    Preprocess.preprocess(validator)
  end

  session_file:parent():mkdir { parents = true }
  vim.cmd { cmd = 'mksession', args = { Vim.command_line_escape(session_file.filename) }, bang = true }

  vim.notify('Session saved: ' .. Session.to_display(session), 'info')
  State.last_session = session
end

function M.load_session(session)
  local session_file = make_filepath(session)
  if not session_file:exists() then
    vim.notify('Session not found: ' .. Session.to_display(session), 'error')
    return
  end

  Session.reflect(session)

  vim.cmd { cmd = 'source', args = { Vim.command_line_escape(session_file.filename) } }
  vim.notify('Session loaded: ' .. Session.to_display(session), 'info')
  State.last_session = session
end

function M.delete_session(session)
  local session_file = make_filepath(session)
  if not session_file:exists() then
    vim.notify('Session not found: ' .. Session.to_display(session), 'error')
    return
  end

  vim.fn.delete(session_file.filename)

  vim.notify('Session deleted: ' .. Session.to_display(session), 'info')
  if State.last_session == session then
    State.last_session = nil
  end
end

function M.sessions()
  local dir = get_base_directory()

  local session_files = vim.fs.find(function(name)
    return name:match('.*%.vim$')
  end, { type = 'file', path = dir.filename, limit = math.huge })

  local result = {}
  for _, mf in ipairs(session_files) do
    local filename = Path:new(mf):make_relative(dir.filename)
    table.insert(result, Session.from_filename(filename))
  end

  return result
end

return M

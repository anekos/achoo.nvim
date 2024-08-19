local M = {}

local Fs = require('achoo.fs')
local Meta = require('achoo.meta')

function M.load(args)
  local meta = Meta.from_text(args)
  Fs.load_session(meta)
end

function M.save(args)
  local meta = Meta.from_text(args)
  Fs.save_session(meta)
end

function M.complete_sessions()
  local result = {}
  for _, meta in ipairs(Fs.sessions()) do
    table.insert(result, Meta.to_text(meta))
  end
  return result
end

return M

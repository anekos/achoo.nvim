local Fs = require('achoo.fs')
local Session = require('achoo.session')

local M = {}

PromptOptions = { prompt = 'Select session', format_item = Session.to_display }

function M.confirm(prompt, callback)
  local res = vim.fn.confirm(prompt, '&Yes\n&No', 3)
  if res == 1 then
    callback()
  end
end

function M.select(candidates, options, on_select)
  if #candidates == 0 then
    return
  end

  if #candidates == 1 then
    on_select(candidates[1])
    return
  end

  vim.ui.select(candidates, options, on_select)
end

function M.select_sessions(callback)
  local ok, _ = pcall(require, 'telescope')
  if not ok then
    vim.ui.select(Fs.sessions(), PromptOptions, callback)
  end

  require('achoo.picker')()
end

return M

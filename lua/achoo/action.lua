local Fs = require('achoo.fs')

local M = {}

function M.edit_session_file(session)
  vim.cmd.edit(Fs.make_filepath(session).filename)
end

return M

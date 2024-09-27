local Icon = require('achoo.icon')

local M = {}

M.last_session = nil
M.auto_save = true
M.confirm_on_leave = true
M.icon = Icon.predefined.ascii
M.preprocess = false
M.session_rotation = false
M.session_rotation_prefix = 'rotated-'
M.session_rotation_limit = 5

return M

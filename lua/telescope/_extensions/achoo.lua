local telescope = require('telescope')

local picker = require('telescope-achoo.picker')

return telescope.register_extension {
  -- setup = function(ext_conf, conf) end,
  exports = {
    achoo = picker,
  },
}

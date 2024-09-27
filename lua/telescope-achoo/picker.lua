local actions = require('telescope.actions')
local conf = require('telescope.config').values
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local state = require('telescope.actions.state')

local Fs = require('achoo.fs')
local Session = require('achoo.session')
local Ui = require('achoo.ui')

local function extract_files(lines)
  local buffers = {}

  for _, line in ipairs(lines) do
    if line:match('^badd') then
      table.insert(buffers, vim.fn.substitute(line, [[^badd +\+[0-9]\+]], '', ''))
    end
  end

  return buffers
end

local function delete_session(prompt_bufnr)
  local current_picker = state.get_current_picker(prompt_bufnr)
  local session = state.get_selected_entry().value
  Ui.confirm('Delete session: ' .. Session.to_display(session), function()
    current_picker:delete_selection(function(_)
      Fs.delete_session(session)
    end)
  end)
end

return function(opts)
  opts = opts or {}

  local sessions = Fs.sessions()

  local finder = finders.new_table {
    results = sessions,
    entry_maker = function(session)
      local display = Session.to_display(session)
      return {
        value = session,
        display = display,
        ordinal = display,
      }
    end,
  }

  local previewer = previewers.new_buffer_previewer {
    title = 'Achoo Session',
    define_preview = function(self, entry, _)
      local session = entry.value

      local filepath = Fs.make_filepath(session).filename

      local lines = {}

      local content = vim.fn.readfile(filepath)
      vim.list_extend(lines, vim.fn.sort(extract_files(content)))

      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
    end,
  }

  pickers
    .new(opts, {
      prompt_title = 'Achoo Session',
      finder = finder,
      previewer = previewer,
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = state.get_selected_entry()
          Fs.load_session(selection.value)
        end)

        map('i', '<C-d>', function()
          delete_session(prompt_bufnr)
        end)

        map('n', 'dd', function()
          delete_session(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

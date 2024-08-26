# Achoo.nvim

Achoo.nvim is a Neovim plugin designed to manage sessions efficiently. It provides commands to save, load, delete, and manage auto-save functionality for your Neovim sessions.

## Features

- Save and load sessions with ease.
- Delete sessions with confirmation.
- Toggle auto-save functionality.
- Command-line completion for session types and names.

## Installation

To install Achoo.nvim, use your preferred Neovim plugin manager. For example, using [lazy.nvim](https://github.com/folke/lazy.nvim):

```vim
{
  'anekos/achoo.nvim',
  opts = {
    auto_save = true,
  },
  cmd = {
    'AchooAutoSave',
    'AchooDelete',
    'AchooLoad',
    'AchooSave',
  },
  keys = {
    { 'Sss', '<Cmd>AchooSave<CR>', mode = { 'n' } },
    { 'Ssr', '<Cmd>AchooLoad<CR>', mode = { 'n' } },
    { 'Sst', '<Cmd>AchooAutoSave<CR>', mode = { 'n' } },
  },
}
```

## Usage

### Commands

- `:AchooSave[!] [session_type]`: Save the current session. Use `!` to overwrite if the session already exists.
- `:AchooLoad`: Load a session by its code.
- `:AchooDelete`: Delete a session by its code. Use `!` to force deletion without confirmation.
- `:AchooAutoSave [on|off]`: Toggle/Set auto-save functionality.

### Command Completion

- **Session Types**: When saving a session, you can complete the session type using available options.
- **Session Codes**: When loading or deleting a session, you can complete the session code from existing sessions.

### Configration

The default values.

```
{
    auto_save = true,
    confirm_on_leave = true,
}
```

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss any changes.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

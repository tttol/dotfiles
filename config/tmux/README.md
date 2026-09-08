# tmux with WezTerm

Home Manager installs `.tmux.conf` and the WezTerm configuration. The tmux
binary is installed through Homebrew at `/opt/homebrew/bin/tmux`.

On a fresh machine, install the plugins once:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Apply the dotfiles with Home Manager, open a new WezTerm window, and press
Ctrl-b followed by Shift-i to install resurrect and continuum.

After updating the configuration and running `home-manager switch --flake . --impure`,
reload the settings in your running tmux session:

```sh
tmux source-file ~/.tmux.conf
```

Alternatively, press Ctrl-b followed by lowercase r. Reopening WezTerm attaches
to the existing tmux server, so it does not reload the tmux configuration.

WezTerm starts `tmux new-session -A -s main`. Every new native window attaches
to this same session and shares its selected tmux window. Cmd+T creates a
tmux window, displayed in the tmux status bar. Cmd+1 through Cmd+9 select
tmux windows. Existing WezTerm shells are not migrated into tmux.

| Shortcut | Action |
| --- | --- |
| Cmd+T | New tmux window in the current directory |
| Cmd+1 through Cmd+9 | Select tmux window |
| Cmd+' | Split left/right |
| Cmd+Shift+' | Split top/bottom |
| Cmd+H/J/K/L | Focus pane |
| Cmd+arrow | Resize pane |
| Cmd+W | Close tmux pane after confirmation |
| Ctrl-b, then D | Detach without terminating the session |
| Ctrl-b, then Ctrl-s | Save snapshot now |
| Ctrl-b, then Ctrl-r | Restore latest snapshot manually |

Continuum saves every minute while an attached client updates the status
line. Save manually before rebooting to include the latest changes. After
rebooting, reopen WezTerm; continuum restores the snapshot on tmux server
startup. This configuration does not launch WezTerm automatically at login.

Resurrect restores tmux windows, panes, layouts, working directories, and
captured pane contents. It does not restore native WezTerm tabs, macOS
window positions, or process memory. Supported programs may be restarted;
other commands, such as development servers, must be restarted manually.
Save editor buffers before rebooting. Snapshots live under
`~/.tmux/resurrect` by default.

References: [resurrect](https://github.com/tmux-plugins/tmux-resurrect),
[continuum](https://github.com/tmux-plugins/tmux-continuum),
[WezTerm SendString](https://wezterm.org/config/lua/keyassignment/SendString.html).

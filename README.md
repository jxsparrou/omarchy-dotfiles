# Omarchy Dotfiles

Personal Bash and Hyprland overrides for an [Omarchy](https://omarchy.org/)
desktop. The Hyprland configuration loads Omarchy's defaults first, then adds
the settings in this repository. This keeps local customizations separate from
the defaults supplied by Omarchy updates.

## Requirements

- Omarchy installed at `/usr/share/omarchy` (or `OMARCHY_PATH` set to its
  installation directory)
- GNU Stow
- Programs referenced by the custom bindings: `eza`, `zeditor`, `steam`,
  `proton-pass`, and `vesktop`

## Repository Layout

This repository is structured as Stow packages. Each top-level directory
mirrors the path it should have below the home directory.

| Package | Installed path | Purpose |
| --- | --- | --- |
| `bash` | `~/.bashrc` | Bash startup customizations |
| `hypr` | `~/.config/hypr/` | Hyprland and related desktop configuration |
| `home-desktop` | `~/.config/hypr/monitors.lua` | Home desktop computer specific monitor layout |
| `macbookair-m1` | `~/.config/hypr/monitors.lua` | M1 macbookair specific monitor layout.
| `work-laptop` | `~/.config/hypr/monitors.lua` | Work laptop specific monitor layout.


## Bash

### `bash/.bashrc`

This file first sources Omarchy's environment bootstrap. That establishes
`OMARCHY_PATH` and updates `PATH`, including for non-interactive shells. It
then returns early for non-interactive shells, so aliases and interactive shell
features are not loaded by scripts.

For interactive shells, it sources Omarchy's standard Bash configuration and
then overrides `ls` with an icon-enabled, detailed `eza` listing:

```bash
alias ls='eza -lah --group-directories-first --icons=auto'
```

## Hyprland

### `hypr/.config/hypr/hyprland.lua`

This is the entry point. It loads Omarchy's Hyprland bootstrap and defaults,
then loads the local monitor, input, bindings, appearance, autostart, and
window-rule files. Local files are loaded after the defaults, allowing them to
override Omarchy settings.

It also enables adaptive variable refresh rate globally (`vrr = 3`) and
enables direct scanout (`direct_scanout = 2`). These settings are generally
useful for games and fullscreen content where the compositor can present a
window directly to the display.

### `hypr/.config/hypr/monitors.lua`

Defines two DisplayPort outputs and a scale factor of 1:

- `DP-1` uses its preferred resolution and refresh rate at position `0x0`.
- `DP-2` uses `2560x1440@144Hz` and starts at `2560x0`, placing it directly to
  the right of the first display.
- `GDK_SCALE` is set to `1` for GTK applications.

Output names and modes must match `hyprctl monitors all` on the target machine.

### `hypr/.config/hypr/windowrules.lua`

Defines workspace and application placement rules:

- Workspaces `1` and `2` are persistent and assigned to `DP-1` and `DP-2`.
- Workspace `5` is assigned to `DP-1` for gaming.
- Steam game windows and gamescope windows are sent to workspace `5`.
- XIVLauncher is sent to workspace `5`, floats, is centered, and is sized to
  half the monitor width and 60 percent of its height.
- Proton Pass floats and opens centered.

### `hypr/.config/hypr/bindings.lua`

Keeps Omarchy's standard bindings unless a binding is explicitly removed with
`hl.unbind`. It then adds or replaces these shortcuts:

| Shortcut | Action |
| --- | --- |
| `Super+Shift+W` | Launch Zed |
| `Super+Shift+S` | Launch Steam |
| `Super+Shift+P` | Launch Proton Pass |
| `Super+Shift+V` | Launch Vesktop |
| `Super+Q` | Close the focused window |
| `Super+W` | Launch the configured Omarchy browser |

The former `Super+Shift+Slash` 1Password binding is removed without a
replacement.

### `hypr/.config/hypr/input.lua`

Currently a commented reference file for keyboard, mouse, touchpad, and
gesture overrides. It has no active settings. Uncomment and adjust a block to
override the Omarchy default input configuration.

### `hypr/.config/hypr/looknfeel.lua`

Currently a commented reference file for gaps, borders, layout, decoration,
animations, and scrolling-layout preferences. It has no active settings.

### `hypr/.config/hypr/autostart.lua`

Reserved for applications and services that should start with Hyprland. It has
no active autostart commands. For example:

```lua
o.launch_on_start("hyprsunset")
```

### `hypr/.config/hypr/misc.lua`

Contains a VRR setting (`vrr = 2`), but `hyprland.lua` does not load this file.
It therefore has no effect in the current configuration. The active VRR setting
is `vrr = 3` in `hyprland.lua`.

### `hypr/.config/hypr/hyprsunset.conf`

Configures hyprsunset with an identity profile at 07:00, which means no color
tint is applied. A commented example shows how to enable a 4000K evening
night-light profile; hyprsunset must also be started from `autostart.lua`.

### `hypr/.config/hypr/xdph.conf`

Configures the Hyprland XDG desktop portal's screencopy behavior. It allows
screen-share tokens by default and uses `hyprland-preview-share-picker` as the
region/window picker.

### `hypr/.config/hypr/.luarc.json`

Lua language-server configuration for editing these files. It adds Hyprland
Lua stubs and declares Omarchy's `hl` and `o` helper objects as known globals,
preventing false editor diagnostics.

## Lua and Hyprland Syntax

Hyprland's Omarchy configuration uses Lua. Lua comments begin with `--`.

```lua
-- A local variable stores a value for this file.
local gamingApps = "^(steam_app.*|gamescope)$"

-- A function call passes a table, written with curly braces.
hl.workspace_rule({
  workspace = "1",
  monitor = "DP-1",
  persistent = true,
})
```

- `local` limits a variable to the current file.
- Strings use quotes; `true` and `false` are Boolean values.
- `{ ... }` creates a Lua table, used here as a named settings object.
- `require("hypr.monitors")` loads a Lua module. Dots map to path separators,
  so it loads `hypr/monitors.lua` from the configured Lua search path.
- `dofile(path)` executes a Lua file at an explicit path; the entry point uses
  it to load Omarchy's bootstrap before modules are available.
- `hl` is Omarchy's lower-level Hyprland helper. Examples include
  `hl.monitor`, `hl.workspace_rule`, `hl.unbind`, and `hl.config`.
- `o` is Omarchy's convenience helper. `o.bind` declares a named keybinding,
  while `o.window` applies rules to windows matching a class pattern.
- Patterns such as `^(steam_app.*|gamescope)$` match a full application class:
  `^` and `$` anchor the beginning and end, `|` means "or", and `.*` matches
  any sequence of characters. The escaped `\\.` in `^XIVLauncher\\.Core$`
  matches a literal period.

Refer to `omarchy menu keybindings --print` for the active binding list and
the [Hyprland documentation](https://wiki.hypr.land/Configuring/Start/) for
available compositor settings.

## Back Up, Install, and Restore with Stow

The commands below use `--target="$HOME"` explicitly, so they work regardless
of where this repository is cloned. Run them from the repository root.

### Back up existing configuration

Do this before the first install. It moves any existing destination files out
of the way without deleting them.

```bash
backup_dir="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir/.config"

[[ -e "$HOME/.bashrc" || -L "$HOME/.bashrc" ]] && mv "$HOME/.bashrc" "$backup_dir/.bashrc"
[[ -e "$HOME/.config/hypr" || -L "$HOME/.config/hypr" ]] && mv "$HOME/.config/hypr" "$backup_dir/.config/hypr"
```

Keep the printed `backup_dir` value or note the newly created directory. If
the target already consists of Stow links from this repository, do not move it;
use the removal command below instead.

### Install the configuration

Preview the links Stow would create, then install them:

```bash
stow --no --verbose --target="$HOME" bash hypr
stow --verbose --target="$HOME" bash hypr
```

The first command is a dry run. The second creates symlinks in the home
directory pointing back to this clone. Changes committed or pulled into this
repository take effect through those links; reload Hyprland after changing its
configuration.

### Back up the repository

The configuration source is the Git repository, so push its commits to a
remote clone for an off-machine backup:

```bash
git status
git add bash hypr README.md
git commit -m "Update dotfiles"
git push
```

### Remove Stow links and restore a previous configuration

First remove only the links Stow created, then move the saved files back. Set
`backup_dir` to the actual backup directory created earlier.

```bash
stow --delete --verbose --target="$HOME" bash hypr

backup_dir="$HOME/dotfiles-backup-YYYYMMDD-HHMMSS"
[[ -e "$backup_dir/.bashrc" || -L "$backup_dir/.bashrc" ]] && mv "$backup_dir/.bashrc" "$HOME/.bashrc"
[[ -e "$backup_dir/.config/hypr" || -L "$backup_dir/.config/hypr" ]] && mv "$backup_dir/.config/hypr" "$HOME/.config/hypr"
```

`stow --delete` removes symlinks but never deletes the files inside this
repository.

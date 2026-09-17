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
| `home-desktop` | `~/.config/hypr/monitors.lua`, `~/.config/mise/`, and `~/.config/environment.d/` | Home desktop-specific settings |
| `macbookair` | `~/.config/hypr/monitors.lua` | M1 MacBook Air monitor layout |


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

### Machine-Specific `monitors.lua`

Monitor layouts live in machine-specific Stow packages rather than the shared
`hypr` package. The home desktop layout at
`home-desktop/.config/hypr/monitors.lua` defines two DisplayPort outputs and a
scale factor of 1:

- `DP-1` uses its preferred resolution and refresh rate at position `0x0`.
- `DP-2` uses `2560x1440@144Hz` and starts at `2560x0`, placing it directly to
  the right of the first display.
- `GDK_SCALE` is set to `1` for GTK applications.

Output names and modes must match `hyprctl monitors all` on the target machine.
Stow exactly one machine package alongside `bash` and `hypr`.

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

Hyprland's Omarchy configuration uses Lua. Lua comments begin with `--`; use
`local` for values that are only needed within the current file.

```lua
-- Reuse a value within this file.
local application_class = "^example-app$"

-- A table supplies named options to a helper.
hl.config({
  input = {
    kb_layout = "us",
  },
})
```

- Strings use quotes; numbers are unquoted; `true`, `false`, and `nil` are
  Boolean and empty values.
- `{ ... }` creates a table. Use it for nested settings, option lists, and
  function arguments with named fields.
- `require("hypr.monitors")` loads `hypr/monitors.lua`. Dots in a module name
  map to path separators. `dofile(path)` executes a Lua file at an explicit
  path and is used by the entry point before modules are available.
- `hl` provides lower-level Hyprland helpers. `o` provides Omarchy convenience
  helpers for common configuration.

### Common Patterns

```lua
-- Add or override a Hyprland setting.
hl.config({
  misc = { vrr = 2 },
})

-- Configure an output. Use `hyprctl monitors all` to discover its name and modes.
hl.monitor({
  output = "DP-1",
  mode = "preferred",
  position = "0x0",
  scale = "1",
})

-- Keep a workspace on a particular output.
hl.workspace_rule({
  workspace = "1",
  monitor = "DP-1",
  persistent = true,
})

-- Add a binding. Unbind a default first when replacing it.
hl.unbind("SUPER + SHIFT + T")
o.bind("SUPER + SHIFT + T", "Open terminal", { launch = "ghostty" })

-- Apply simple rules to windows whose class matches a regular expression.
o.window("^example-app$", {
  workspace = "3",
  float = true,
})

-- Use a full rule when matching more than just the class.
hl.window_rule({
  match = {
    class = "^example-app$",
    title = "^Settings$",
  },
  center = true,
  size = { "monitor_w*0.5", "monitor_h*0.6" },
})
```

Window match fields accept regular expressions. `^` and `$` match the start
and end of a value, `|` means "or", and `.*` matches any sequence of
characters. In a Lua string, write a literal regex backslash as `\\`, such as
`"^example\\.app$"` to match a period.

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
mkdir -p "$backup_dir/.config/mise" "$backup_dir/.config/environment.d"

[[ -e "$HOME/.bashrc" || -L "$HOME/.bashrc" ]] && mv "$HOME/.bashrc" "$backup_dir/.bashrc"
[[ -e "$HOME/.config/hypr" || -L "$HOME/.config/hypr" ]] && mv "$HOME/.config/hypr" "$backup_dir/.config/hypr"
[[ -e "$HOME/.config/mise/config.toml" || -L "$HOME/.config/mise/config.toml" ]] && mv "$HOME/.config/mise/config.toml" "$backup_dir/.config/mise/config.toml"
[[ -e "$HOME/.config/environment.d/nvidia-shader-cache.conf" || -L "$HOME/.config/environment.d/nvidia-shader-cache.conf" ]] && mv "$HOME/.config/environment.d/nvidia-shader-cache.conf" "$backup_dir/.config/environment.d/nvidia-shader-cache.conf"
[[ -e "$HOME/.config/environment.d/omarchy-firefox-wayland.conf" || -L "$HOME/.config/environment.d/omarchy-firefox-wayland.conf" ]] && mv "$HOME/.config/environment.d/omarchy-firefox-wayland.conf" "$backup_dir/.config/environment.d/omarchy-firefox-wayland.conf"
```

Keep the printed `backup_dir` value or note the newly created directory. If
the target already consists of Stow links from this repository, do not move it;
use the removal command below instead.

### Install the configuration

Preview the links Stow would create, then install them:

```bash
stow --no --verbose --target="$HOME" bash hypr home-desktop
stow --verbose --target="$HOME" bash hypr home-desktop
```

The first command is a dry run. The second creates symlinks in the home
directory pointing back to this clone. Replace `home-desktop` with `macbookair`
when installing on the MacBook. If existing files have not been backed up and
you intentionally want Stow to take them into the package, add `--adopt` to
the Stow command. Changes committed or pulled into this repository take effect
through those links; reload Hyprland after changing its configuration.

### Back up the repository

The configuration source is the Git repository, so push its commits to a
remote clone for an off-machine backup:

```bash
git status
git add .
git commit -m "Update dotfiles"
git push
```

### Remove Stow links and restore a previous configuration

First remove only the links Stow created, then move the saved files back. Set
`backup_dir` to the actual backup directory created earlier.

```bash
stow --delete --verbose --target="$HOME" bash hypr home-desktop

backup_dir="$HOME/dotfiles-backup-YYYYMMDD-HHMMSS"
[[ -e "$backup_dir/.bashrc" || -L "$backup_dir/.bashrc" ]] && mv "$backup_dir/.bashrc" "$HOME/.bashrc"
[[ -e "$backup_dir/.config/hypr" || -L "$backup_dir/.config/hypr" ]] && mv "$backup_dir/.config/hypr" "$HOME/.config/hypr"
[[ -e "$backup_dir/.config/mise/config.toml" || -L "$backup_dir/.config/mise/config.toml" ]] && mkdir -p "$HOME/.config/mise" && mv "$backup_dir/.config/mise/config.toml" "$HOME/.config/mise/config.toml"
[[ -e "$backup_dir/.config/environment.d/nvidia-shader-cache.conf" || -L "$backup_dir/.config/environment.d/nvidia-shader-cache.conf" ]] && mkdir -p "$HOME/.config/environment.d" && mv "$backup_dir/.config/environment.d/nvidia-shader-cache.conf" "$HOME/.config/environment.d/nvidia-shader-cache.conf"
[[ -e "$backup_dir/.config/environment.d/omarchy-firefox-wayland.conf" || -L "$backup_dir/.config/environment.d/omarchy-firefox-wayland.conf" ]] && mkdir -p "$HOME/.config/environment.d" && mv "$backup_dir/.config/environment.d/omarchy-firefox-wayland.conf" "$HOME/.config/environment.d/omarchy-firefox-wayland.conf"
```

`stow --delete` removes symlinks but never deletes the files inside this
repository.

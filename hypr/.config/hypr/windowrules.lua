-- Custom window rules. Syntax below.

-- Omarchy convenience helper
-- o.window("CLASS", {
--     rules
-- })

-- Full Hyprland rule
-- hl.window_rule({
--     match = {
--         initial_class = "PATTERN",
--         title = "PATTERN",
--         -- etc.
--     },
--     rules
-- })

-------------------------------------------------------------------------------------------
-- Move gaming apps to workspace 5 to keep games off main workspaces
local gamingApps = "^(steam_app.*|gamescope)$"

o.window(gamingApps, {
	workspace = "5"
})
--xivlauncher too
hl.window_rule({
	match = {
		initial_class = "^XIVLauncher\\.Core$",
	},
	workspace = "5",
	float = true,
	center = true,
	size = { "monitor_w*0.5", "monitor_h*0.6" },
})

-- Proton Pass
o.window("^Proton Pass$", {
	float = true,
	center = true,
})

-- PIP
hl.window_rule({
	match = {
		class = "^(zen)$",
		title = "^(Picture-in-Picture)$",
		tag = "pip*"
	},

	tile = true,
})

-- Obsidian 
hl.window_rule({
	match = {
		class = "^(md\\.obsidian\\.Obsidian)$"
	},

	tile = false,
	size = {"monitor_w*0.5", "monitor_h*0.6" },
})

-- RustDesk remote sessions
hl.window_rule({
    match = {
        class = "^(rustdesk)$",
        title = ".* - Remote Desktop - RustDesk$",
    },

    workspace = "6",
})

-- Changing the default Steam window size
o.window({ class = "steam", title = "Steam" }, {
  center = true,
  size = { "monitor_w*0.5", "monitor_h*0.6" }, -- e.g. { 1400, 900 } or { "monitor_w*0.7", "monitor_h*0.75" }
})

-- 1Password main window
-- Default Omarchy rule matches class "^(1[p|P]assword)$" (see /usr/share/omarchy/default/hypr/apps/1password.lua),
-- but `hyprctl clients` shows class "com.onepassword.OnePassword", so it never matched and stayed tiled.
-- Re-apply the same no_screen_share + floating-window treatment to the real class.
hl.window_rule({
    match = {
        class = "^(com\\.onepassword\\.OnePassword)$",
    },

    no_screen_share = true,
    tag = "+floating-window",
})

-- Flea file manager (XDG default, StartupWMClass "com.thisisgm.flea")
-- Standard Omarchy float is hardcoded to 875x600 (see /usr/share/omarchy/default/hypr/apps/system.lua),
-- so float + center without size/tag to let Flea pick its own size.
hl.window_rule({
    match = {
        class = "^(com\\.thisisgm\\.flea)$",
    },

    float = true,
    center = true,
})

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
--Workspace Rules
hl.workspace_rule({
	workspace = "1",
	monitor = "DP-1",
	persistent = true,
})

hl.workspace_rule({
	workspace = "2",
	monitor = "DP-2",
	persistent = true,
})

hl.workspace_rule({
	workspace = "5",
	monitor = "DP-1"
})

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


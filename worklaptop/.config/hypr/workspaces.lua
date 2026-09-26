local LEFT_MON = "HDMI-A-1"
local RIGHT_MON = "DP-3"
local SCREEN = "eDP-1"

hl.workspace_rule({
	workspace = "1",
	monitor = LEFT_MON,
	persistent = true,
})

hl.workspace_rule({
	workspace = "2",
	monitor = RIGHT_MON,
	persistent = true,
})

hl.workspace_rule({
	workspace = "3",
	monitor = SCREEN,
	persistent = true,
})

hl.workspace_rule({
	workspace = "5",
	monitor = "DP-1"
})

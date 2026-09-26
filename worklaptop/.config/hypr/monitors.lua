-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Example: output can be found with hyprctl monitors. Edit variables.lua for the monitor outputs instead of here directly
-- hl.monitor({
--     output    = "MONITOR1",
--     mode      = "1920x1080@60",
--     position  = "0x0",
--     scale     = "1",
-- })

local omarchy_gdk_scale = 1
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

local SCREEN = "eDP-1"
local LEFT_MON = "HDMI-A-1"
local RIGHT_MON = "DP-3"

hl.monitor({
    output    = LEFT_MON,
    mode      = "1920x1080@74.97Hz",
    position  = "0x0",
    scale     = "1",
})

hl.monitor({
	output = RIGHT_MON,
	mode = "1920x1080@74.97Hz",
	position = "1920x0",
	scale = "1",
})

hl.monitor({
	output = SCREEN,
	mode = "1920x1200@60.00Hz",
	position = "1280x1080",
	scale = "1.5",
})

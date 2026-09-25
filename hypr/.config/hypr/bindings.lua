-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")


-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")


-- Rebind for Omawrite to Zed - edited out because i decided i wanted to give it a try
-- hl.unbind("SUPER + SHIFT + W")
-- o.bind("SUPER + SHIFT + W", "Zed", {
--    launch = "zeditor"
-- })

-- Steam
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Steam", {
    launch = "steam"
})

-- Vesktop
o.bind("SUPER + SHIFT + V" , "Vesktop/Discord", {
    launch = "vesktop"
})

-- Add the proper close key
hl.unbind("SUPER + W")
o.bind("SUPER + Q", "Close Window", hl.dsp.window.close())

-- Add a browser key
o.bind("SUPER + W", "Zen Web Browser", { omarchy = "browser" })

-- Calculator
hl.unbind("SUPER + SHIFT + C")
hl.unbind("SUPER + CTRL + Q")
o.bind("SUPER + SHIFT + C", "Calculator", { launch = "omacalc" })

-- Creating a suspend button. Since Lock is super ctrl l, i think I am going to add shift on the same key
o.bind("SUPER + SHIFT + CTRL + L", "Suspend", {launch = "systemctl suspend"})

-- flea --default: begin. Written by `flea --default`; `flea --default off` removes the block whole.
hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager", { launch = 'flea --gui' })
hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { launch = 'flea --gui "$(omarchy-cmd-terminal-cwd)"' })
-- flea --default: end.

-- flea --picker: begin. Written by `flea --picker`; `flea --picker off` removes the block whole.
o.window("com.thisisgm.flea.picker", { tag = "+floating-window" })
-- flea --picker: end.


-- move to silently moving windows between workspaces
for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  hl.unbind("SUPER + " .. key)
  hl.unbind("SUPER + SHIFT + " .. key)
  hl.unbind("SUPER + SHIFT + ALT + " .. key)
  o.bind("SUPER + " .. key, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = tostring(workspace) }))
  o.bind("SUPER + SHIFT + " .. key, "Move window silently to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace), follow = false }))
  o.bind("SUPER + SHIFT + ALT + " .. key, "Move window to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace) }))
end

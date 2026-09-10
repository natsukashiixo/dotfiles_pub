-- Migrated from hyprland.conf to hyprland.lua
-- Backup of originals: backup_20260909_194615/

---@module 'hl'

-- source files
require("imports.vars")
require("imports.monitors")
require("imports.autostart")
require("imports.input")
require("imports.cursor")
require("imports.general")
require("imports.misc")
require("imports.decorations")
require("imports.animations")
require("imports.dwindle")
require("imports.windowrules")
require("imports.layerrules")
require("imports.binds")

-- Autostart (from original hyprland.conf)
hl.on("hyprland.start", function()
    hl.exec_cmd("timeout 10 sh -c \"while ! hyprctl monitors | grep -q 'G32QC'; do sleep 0.1; done\"")
end)

-- hyprland.lua — DRAFT translation of the live ~/.config/hypr/hyprland.conf (Hyprland 0.56.2)
-- Generated 2026-10-19 from the LIVE config (live = source of truth), not the repo copy.
-- Do NOT copy into ~/.config/hypr until the plan's validation steps pass:
-- if hyprland.lua exists it takes precedence over hyprland.conf on the next start/full-reset.
--
-- Load order mirrors the old `source =` order. Each require() runs in its own protected
-- scope, so a runtime error in one module does not abort the others.

require("modules.env")          -- was imports/vars.conf
require("modules.monitors")     -- was imports/monitors.conf
require("modules.autostart")    -- was imports/autostart.conf
require("modules.input")        -- was imports/input.conf
require("modules.cursor")       -- was imports/cursor.conf
require("modules.general")      -- was imports/general.conf
require("modules.misc")         -- was imports/misc.conf
require("modules.decorations")  -- was imports/decorations.conf
require("modules.animations")   -- was imports/animations.conf
require("modules.windowrules")  -- was imports/windowrules.conf
-- require("modules.layerrules") -- imports/layerrules.conf was commented out in the live config
require("modules.binds")        -- was imports/binds.conf
-- imports/dwindle.conf was never sourced (layout is monocle); dwindle.pseudotile no longer exists in 0.56.

-- was imports/windowrules.conf. `float = on` -> true. Regex is RE2; `negative:` prefix negates.
local function float_class(name, class)
    hl.window_rule({ name = name, match = { class = class }, float = true })
end
local function float_title(name, title)
    hl.window_rule({ name = name, match = { title = title }, float = true })
end

float_class("File-Progress_Float", "file_progress")
float_class("Confirm-Dialog_Float", "confirm")
float_class("Dialog_Float", "dialog")
float_class("Download_Float", "download")

hl.window_rule({
    name  = "Notification_Float_Top_Right",
    match = { class = "^(notification)$" },
    float = true,
    size  = { 64, 256 },
    move  = { "monitor_w*0.9", "15" }, -- was ((monitor_w*0.9)) (15)
})

float_class("Error_Float", "error")
float_class("Splash_Float", "splash")
float_class("Confirm-Reset_Float", "confirmreset")
float_title("Open-File_Float", "Open File")
float_title("Branch-Dialog_Float", "branchdialog")
float_class("LXAppearance_Float", "Lxappearance")

hl.window_rule({
    name      = "Rofi_Centered_No_Anim",
    match     = { class = "Rofi" },
    float     = true,
    animation = "none", -- VERIFY: if configerrors rejects this, use `no_anim = true` instead
    center    = true,
})

float_class("File-Roller_Float", "file-roller")
float_title("Picture-in-Picture_Float", "^(Picture-in-Picture)$")

-- 2026-11-21: removed Steam_Chat_Float_Centered (floated every Steam window not titled exactly "Steam").
-- Steam's startup windows map with an empty/other title, so the main client floated above the
-- monocle stack without taking focus. Real transient dialogs still auto-float via X11 hints.

hl.window_rule({
    name  = "Steam_Friends-List_Float",
    match = { class = "steam", title = "Friends List" },
    float = true,
    size  = { 400, 600 },
    move  = { "monitor_w*0.84", "monitor_h*0.02" },
})

-- 2026-11-23: Wine/Proton games (class "something.exe", Steam's "steam_app_<id>") sometimes float
-- themselves (kinkoi.exe did), which drops them out of the monocle cycle and the fullscreen rule
-- below. Tile them. If a game breaks when tiled, add a narrower exception above this rule;
-- `refocus-game` (~/.local/bin) gets a floating one back.
hl.window_rule({
    name  = "Games_Tile",
    match = { class = "^(.*\\.exe|steam_app_[0-9]+)$" },
    tile  = true,
})

-- HTPC: every tiled window opens fullscreen (no gaps/waybar). Dialogs, popups and the floating
-- rules above are excluded because `float = false` only matches tiled windows.
hl.window_rule({
    name       = "HTPC_Fullscreen_Tiled",
    match      = { float = false },
    fullscreen = true,
})

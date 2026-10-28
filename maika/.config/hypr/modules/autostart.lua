-- was imports/autostart.conf. exec-once -> the hyprland.start event (runs once, not on reload).
-- `[workspace 1 silent] cmd` -> hl.exec_cmd(cmd, { workspace = "1 silent" }).
-- exec_cmd runs `sh -c cmd`, so pipes/&&/$(...) keep working.

hl.on("hyprland.start", function()
    -- D8 (owner: replace wl-clipboard-history with cliphist; kept for script compatibility only, no bind/rofi entry).
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("dunst")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")

    -- antimicrox re-enabled 2026-10-25 (Option C step 2). --eventgen uinput: don't let XDG_SESSION_TYPE pick XTest (I37).
    hl.exec_cmd("antimicrox --hidden --eventgen uinput --profile ~/.config/antimicrox/generic.gamecontroller.amgp")

    -- this is kind of brittle and might also not be needed since TVs generally only have 1 monitor
    hl.exec_cmd("xrandr --output $(hyprctl monitors -j | jq -r '.[0] | .name') --primary")

    -- ssh. D7 (owner: rely on systemd's ssh-agent.socket): the autostart `ssh-agent -a` line was dropped;
    -- the socket is exported by D3 in env.lua. D9 (owner: AddKeysToAgent yes in ~/.ssh/config): the autostart
    -- `ssh-add` line was dropped; keys are added to the agent on first use.

    -- Steam Big Picture deliberately disabled by the owner (never released the controller); keep disabled.
    -- hl.exec_cmd("steam -tenfoot", { workspace = "1 silent" })
    -- hl.exec_cmd("heroic", { workspace = "1 silent" })
    hl.exec_cmd("lutris", { workspace = "1 silent" })
    hl.exec_cmd("rpcs3", { workspace = "1 silent" })
    -- hl.exec_cmd("retroarch", { workspace = "1 silent" })

    -- D1 (owner: Option C, see ../../../../TODO.md), switched 2026-10-25 (step 3).
    -- com.github.iwalton3.jellyfin-media-player is not installed.
    hl.exec_cmd("flatpak run org.jellyfin.JellyfinDesktop --fullscreen --tv", { workspace = "1 silent" })

    hl.exec_cmd("gtk-launch youtube-pwa", { workspace = "1 silent" })
end)

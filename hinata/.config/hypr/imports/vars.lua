-- Converted from imports/vars.lua (hyprconf2lua failed on line 24)
-- Original had `env = WAYLAND_TEXT_INPUT=3` — corrected to `,` separator

---@module 'hl'

-- █▀▀ █▄░█ █░█
-- ██▄ █░▀█ ▀▄▀

-- NVIDIA ENV VARS PLS NO DELET
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- force wayland in electron
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Workaround for wrong wpaperd texture on vertical screen
-- https://github.com/hyprwm/Hyprland/issues/9408#issuecomment-2661608482
hl.config({
    render = {
        expand_undersized_textures = false,
    },
})

--FCITX ENV VARS
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")

--maybe dangerous, theoretically forces all wayland windows to use text input v3
hl.env("WAYLAND_TEXT_INPUT", "3")

--ssh socket
hl.env("SSH_AUTH_SOCK", "$XDG_RUNTIME_DIR/ssh-agent.socket")

-- QT6 dark mode stuff ig
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("GTK2_RC_FILES", "/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc")
hl.env("QT_STYLE_OVERRIDE", "Adwaita-Dark")

-- set XDG DIRS
hl.env("XDG_CACHE_HOME", "$HOME/.cache")
hl.env("XDG_CONFIG_HOME", "$HOME/.config")

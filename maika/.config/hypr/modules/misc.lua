-- was imports/misc.conf
hl.config({
    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms  = true,
    },
    -- `misc.vfr` (commented out in the live config) moved to `debug.vfr` in 0.55+:
    -- debug = { vfr = true },

    -- sry vaxry but its gonna be annoying to deal with these on a tv
    ecosystem = {
        no_update_news  = true,
        no_donation_nag = true,
    },
})

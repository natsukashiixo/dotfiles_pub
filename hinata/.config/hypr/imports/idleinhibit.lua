---@module 'hl'

-- █▀▄▀█ █ █▀ █▀▀

-- █░▀░█ █ ▄█ █▄▄

hl.config({
    idle_inhibit = {
        apps = {
            { class = "org.gnome.Solanum",              inhibit = "focus" },
            { class = "com.github.johnfactotum.Foliate", inhibit = "focus" },
            { class = "mpv",                             inhibit = "focus" },
            { class = "firefox",                         inhibit = "fullscreen" },
        },
    },
})

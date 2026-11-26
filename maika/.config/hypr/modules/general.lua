-- was imports/general.conf
hl.config({
    general = {
        gaps_in     = 0, -- no margins: a tiled window that lost fullscreen still fills the screen
        gaps_out    = 0,
        border_size = 0,
        col = {
            active_border   = "rgba(ffffffff)", -- was 0xffFFFFFF
            inactive_border = "rgba(acacacff)", -- was 0xffacacac
        },
        -- no_border_on_floating = false
        layout           = "monocle",
        resize_on_border = true, -- lets see if this is ok
    },
})

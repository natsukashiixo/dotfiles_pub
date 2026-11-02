---@module 'hl'

-- Blur playground. Loaded last in hyprland.lua so it overrides everything else.
--
-- Hyprland 0.57 only has ONE global blur variant (decoration.blur.variant);
-- window/layer rules can't set it per-window. So the "acrylic bar, prism ghostty"
-- setup is faked by swapping the global variant whenever focus changes:
--   ghostty focused  -> FOCUSED_VARIANT (bar turns prism too while this is active)
--   anything else    -> DEFAULT_VARIANT
--
-- Variants: kawase (plain), frost, ripple, drops, water, fluid_jar, prism,
--           heat_shimmer, acrylic, aurora, haze
-- Live-test anything without reloading:  hyprctl eval 'hl.config({ decoration = { blur = { variant = "haze" } } })'
-- Read a value back:                     hyprctl getoption decoration:blur:acrylic:clarity

local DEFAULT_VARIANT = "acrylic"
local FOCUSED_VARIANT = "prism"
local FOCUSED_CLASS   = "ghostty" -- substring match on window class

hl.config({
    decoration = {
        blur = {
            enabled = true,
            size    = 8,
            passes  = 2,
            -- noise      = 0.0117,
            -- contrast   = 0.8916,
            -- brightness = 1.0,
            -- vibrancy   = 0.1696,

            -- acrylic knobs (current values = defaults)
            acrylic = {
                bulb       = 48,    -- width of the curved edge, px
                refraction = 24,    -- edge refraction displacement, px
                clarity    = 0.32,  -- how much sharp backdrop shows through (0-1)
                aberration = 0.225, -- chromatic aberration on the edge
                -- tint    = "rgba(ecc06c14)", -- DMS themes this in dms/colors.lua; uncomment to override
                -- defaults
                -- bulb = 48
                --refraction = 24
                --clarity = 0.82
                --abberation = 0.025
            },

            -- prism uses the glass knobs
            glass = {
                size       = 67, -- pattern size, px
                refraction = 20, -- max refraction displacement, px
                roughness  = 0.67,
                -- defaults
                -- size = 40
                -- refraction = 20
                -- roughness = 1.0
            },
        },
    },
})

-- DMS bar only had xray, not blur
hl.layer_rule({
    match = { namespace = "^dms:bar$" },
    blur  = true,
})

local current = nil
local function apply_variant()
    local w = hl.get_active_window()
    local class = w and w.class or ""
    local want = class:find(FOCUSED_CLASS, 1, true) and FOCUSED_VARIANT or DEFAULT_VARIANT
    if want ~= current then
        hl.config({ decoration = { blur = { variant = want } } })
        current = want
    end
end

hl.on("window.active", apply_variant)
apply_variant()

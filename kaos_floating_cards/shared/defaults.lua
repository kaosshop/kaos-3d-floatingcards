Defaults = {}

-- The canonical shape of a float. Anything missing on a saved record is
-- filled in from here, so old JSON keeps working after an update.
Defaults.Card = {
    id = '',
    name = 'Untitled float',
    enabled = true,
    created = 0,
    updated = 0,

    anchor = {
        mode = 'world',            -- world | entity | bone | me | plate
        pos = { x = 0.0, y = 0.0, z = 0.0 },
        entity = 0,                -- network id
        bone = '',
        plate = '',
        offset = { x = 0.0, y = 0.0, z = 1.0 },
    },

    facing = {
        mode = 'camera',           -- camera | upright | fixed
        heading = 0.0,
        pitch = 0.0,
        roll = 0.0,
        readableFromBehind = false,
    },

    size = {
        mode = 'world',            -- world | screen
        scale = 1.0,
        minPx = 40,
        maxPx = 900,
    },

    style = {
        background = 'solid',      -- solid | glass | pill | holo | bubble | paper | none
        color = '#0E0E11',
        opacity = 0.90,
        padding = 24,
        gap = 12,
        radius = 16,
        border = 1,
        borderColor = '#FFFFFF14',
        accent = '#FFFFFF',
        align = 'centre',          -- left | centre | right
        fixedWidth = 0,            -- 0 = fit to content
        glow = 0.0,
        glowColor = '',            -- '' = use accent
        innerHighlight = true,
        tail = false,
        font = 'clean',            -- clean | poster | mono | tech | editorial | soft | neon | terminal
    },

    blocks = {},

    motion = {
        bob     = { on = false, amount = 0.06, speed = 1.0 },
        pulse   = { on = false, amount = 0.05, speed = 1.0 },
        sway    = { on = false, amount = 4.0, speed = 1.0 },
        spin    = { on = false, speed = 0.4 },
        orbit   = { on = false, radius = 0.35, speed = 0.7 },
        flicker = { on = false, amount = 0.4, speed = 1.0 },
        appear  = { mode = 'fade', duration = 0.35 }, -- none | fade | rise | pop
    },

    effects = {
        beam   = { on = false, color = '#FFFFFF', radius = 0.35, height = 1.4, opacity = 0.18 },
        ring   = { on = false, color = '#FFFFFF', radius = 0.6, speed = 0.6, opacity = 0.35 },
        tether = { on = false, color = '#FFFFFF', opacity = 0.35 },
        shadow = { on = false, radius = 0.5, opacity = 0.3 },
    },

    rules = {
        distance = 60.0,
        fade = 12.0,
        hideCloserThan = 0.0,
        hideBehindWalls = false,
        jobs = {},
        groups = {},
        hours = { from = 0, to = 24 },
        interact = {
            on = false,
            key = 'E',
            label = 'Interact',
            radius = 2.0,
            action = 'message',    -- message | command | client | server
            payload = '',
        },
    },
}

Defaults.Block = {
    text = {
        type = 'text',
        text = 'New text',
        font = 'Inter',
        size = 28,
        weight = 700,
        letterSpacing = 0.0,
        color = '#FFFFFF',
        style = 'plain',           -- plain | outline | glow | shadow
        align = 'inherit',
        opacity = 1.0,
        uppercase = false,
        italic = false,
        tabular = false,
        nearOnly = false,
        nearDistance = 6.0,
    },
    image = {
        type = 'image',
        src = '',
        width = 180,
        height = 0,                -- 0 = auto
        radius = 8,
        opacity = 1.0,
        fit = 'cover',
        nearOnly = false,
        nearDistance = 6.0,
    },
    icon = {
        type = 'icon',
        glyph = 'star',
        emoji = '',
        size = 48,
        color = '#FFFFFF',
        background = '',
        opacity = 1.0,
        nearOnly = false,
        nearDistance = 6.0,
    },
    badge = {
        type = 'badge',
        text = 'BADGE',
        color = '#0E0E11',
        background = '#FFFFFF',
        size = 13,
        radius = 999,
        uppercase = true,
        letterSpacing = 0.12,
        opacity = 1.0,
        nearOnly = false,
        nearDistance = 6.0,
    },
    divider = {
        type = 'divider',
        color = '#FFFFFF22',
        thickness = 1,
        width = 100,               -- percent
        opacity = 1.0,
        nearOnly = false,
        nearDistance = 6.0,
    },
    bar = {
        type = 'bar',
        value = 60,
        color = '#FFFFFF',
        track = '#FFFFFF1A',
        height = 8,
        width = 220,
        radius = 999,
        label = '',
        opacity = 1.0,
        nearOnly = false,
        nearDistance = 6.0,
    },
    key = {
        type = 'key',
        key = 'E',
        label = 'to interact',
        color = '#FFFFFF',
        background = '#FFFFFF14',
        size = 14,
        opacity = 1.0,
        nearOnly = true,
        nearDistance = 6.0,
    },
    row = {
        type = 'row',
        gap = 10,
        align = 'centre',
        children = {},
        opacity = 1.0,
        nearOnly = false,
        nearDistance = 6.0,
    },
}

Defaults.Theme = {
    name = 'Kaos',
    accent = '#FFFFFF',
    line = '#FFFFFF14',
    hover = '#FFFFFF0D',
    panel = '#0B0B0D',
}

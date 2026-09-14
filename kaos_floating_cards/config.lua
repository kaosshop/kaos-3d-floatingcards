Config = {}

-- ────────────────────────────────────────────────────────────────
--  Kaos 3D Floating Cards
--  Everything here is plain Lua. No database, no props, no stream.
-- ────────────────────────────────────────────────────────────────

Config.Brand = 'KAOS STUDIO'
Config.Tagline = 'Floating 3D cards'

-- 'auto' detects esx / qb / qbox, otherwise 'standalone'
Config.Framework = 'auto'

-- Command + keybind that opens the studio
Config.Command = 'floats'
Config.OpenKey = 'F7'            -- set to false to disable the mapped key
Config.RegisterKeyMapping = true

-- Default language. Players can override it in Settings (saved locally).
Config.DefaultLocale = 'en'

-- ── Rendering ───────────────────────────────────────────────────
Config.Render = {
    maxActiveCards = 24,         -- how many cards can hold a render slot at once
    scanInterval   = 500,        -- ms between distance re-scans
    defaultDistance = 60.0,      -- metres, used when a card has no rule
    fadeBand        = 12.0,      -- metres of fade before the limit
    occlusionChecks = true,      -- allow "hide behind walls" rule to raycast
}

-- ── Access control ──────────────────────────────────────────────
-- Layered: any one of these passing grants edit rights.
Config.Access = {
    aceEnabled   = true,
    acePermission = 'kaos.floats',

    groupsEnabled = true,
    groups = { 'admin', 'superadmin', 'god', 'owner' },

    jobsEnabled = false,
    jobs = {
        -- ['police'] = 3,
    },

    identifiersEnabled = false,
    identifiers = {
        -- 'license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    },

    -- Everyone can edit. Handy on a dev server, never on live.
    openToEveryone = false,
}

-- ── Storage ─────────────────────────────────────────────────────
Config.Storage = {
    file = 'data/floats.json',
    presetsFile = 'data/presets.json',
    autosaveSeconds = 0,         -- 0 = save on every change only
    backups = true,              -- keep data/floats.backup.json
}

-- ── AI card generation (Google Gemini) ──────────────────────────
-- Free key: https://aistudio.google.com/docs/api-key
-- Put the key in server.cfg instead if you prefer:
--   set kaos_gemini_key "AIza..."
Config.AI = {
    enabled   = true,
    apiKey    = '',                       -- falls back to convar kaos_gemini_key
    model     = 'gemini-2.0-flash',       -- gemini-2.0-flash | gemini-2.5-flash | gemini-1.5-flash
    endpoint  = 'https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent',
    timeoutMs = 20000,
    cooldownSeconds = 4,                  -- per player
    maxPromptLength = 600,
}

-- ── Interaction safety ──────────────────────────────────────────
-- Commands a card is never allowed to run, whatever the saved record says.
Config.BlockedCommands = {
    'quit', 'restart', 'stop', 'start', 'refresh', 'ensure',
    'add_ace', 'remove_ace', 'add_principal', 'remove_principal',
    'sv_maxclients', 'exec', 'load_server_icon', 'set', 'sets', 'setr'
}

-- ── Studio defaults ─────────────────────────────────────────────
Config.Studio = {
    freecamSpeed = 1.0,
    theme = 'kaos',              -- kaos | monochrome | ember | mint | violet | ice | paper
    alwaysOnTopPreview = true,
    showKeyHints = true,
}

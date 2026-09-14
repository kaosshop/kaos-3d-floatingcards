AI = {}

local cooldowns = {}

local SYSTEM_PROMPT = [[
You design floating 3D information cards for a GTA V roleplay server.
You reply with ONE JSON object and nothing else. No markdown, no code fence, no commentary.

Shape:
{
  "name": "short title, max 32 chars",
  "style": {
    "background": "solid|glass|pill|holo|bubble|paper|none",
    "color": "#RRGGBB",
    "opacity": 0.0-1.0,
    "padding": 12-48,
    "gap": 4-24,
    "radius": 0-32,
    "border": 0-3,
    "borderColor": "#RRGGBBAA",
    "accent": "#RRGGBB",
    "align": "left|centre|right",
    "glow": 0.0-1.0,
    "font": "clean|poster|mono|tech|editorial|soft|neon|terminal"
  },
  "blocks": [
    { "type":"text",   "text":"...", "size":12-72, "weight":300-900, "color":"#RRGGBB",
      "style":"plain|outline|glow|shadow", "letterSpacing":-0.05-0.3, "uppercase":true|false },
    { "type":"badge",  "text":"...", "background":"#RRGGBB", "color":"#RRGGBB", "size":10-18 },
    { "type":"icon",   "emoji":"single emoji", "size":24-72 },
    { "type":"divider","color":"#RRGGBBAA", "thickness":1 },
    { "type":"bar",    "value":0-100, "color":"#RRGGBB", "height":4-16, "label":"..." },
    { "type":"key",    "key":"E", "label":"to interact" }
  ],
  "motion": {
    "bob":   { "on": bool, "amount": 0.0-0.3, "speed": 0.2-3.0 },
    "pulse": { "on": bool, "amount": 0.0-0.2, "speed": 0.2-3.0 },
    "spin":  { "on": bool, "speed": 0.1-2.0 },
    "flicker": { "on": bool, "amount": 0.0-1.0, "speed": 0.2-3.0 }
  },
  "effects": {
    "beam":   { "on": bool, "color": "#RRGGBB", "radius": 0.1-1.5, "height": 0.5-4.0, "opacity": 0.0-0.6 },
    "ring":   { "on": bool, "color": "#RRGGBB", "radius": 0.2-2.0, "opacity": 0.0-0.8 },
    "shadow": { "on": bool, "radius": 0.2-1.5, "opacity": 0.0-0.6 }
  },
  "rules": { "distance": 5-200, "fade": 0-40 }
}

Rules of thumb:
- 2 to 5 blocks. A card is read at a glance, not studied.
- One clear hierarchy: a small label, a big value, a quiet caption.
- Prices and numbers get the largest size and the tightest letter spacing.
- Neon and hologram looks use background "holo" or "none", a glowing text style and a beam.
- Signs on shopfronts use "solid" with a near-black colour.
- Never invent fields that are not listed. Omit anything you do not need.
]]

local function getKey()
    if Config.AI.apiKey and Config.AI.apiKey ~= '' then return Config.AI.apiKey end
    local convar = GetConvar('kaos_gemini_key', '')
    if convar ~= '' then return convar end
    return nil
end

local function stripFence(text)
    text = text:gsub('^%s*```json', ''):gsub('^%s*```', ''):gsub('```%s*$', '')
    return Kaos.Trim(text)
end

--- Turns the model reply into a real card record, or nil.
local function buildCard(payload)
    if type(payload) ~= 'table' then return nil end

    local card = Kaos.DeepCopy(Defaults.Card)
    card.id = Kaos.Uuid()
    card.name = type(payload.name) == 'string' and payload.name:sub(1, 32) or 'AI float'

    if type(payload.style) == 'table' then
        for k, v in pairs(payload.style) do
            if card.style[k] ~= nil then card.style[k] = v end
        end
    end

    for _, group in ipairs({ 'motion', 'effects' }) do
        if type(payload[group]) == 'table' then
            for name, values in pairs(payload[group]) do
                if type(card[group][name]) == 'table' and type(values) == 'table' then
                    for k, v in pairs(values) do
                        if card[group][name][k] ~= nil then card[group][name][k] = v end
                    end
                end
            end
        end
    end

    if type(payload.rules) == 'table' then
        card.rules.distance = tonumber(payload.rules.distance) or card.rules.distance
        card.rules.fade = tonumber(payload.rules.fade) or card.rules.fade
    end

    card.blocks = {}
    if type(payload.blocks) == 'table' then
        for _, raw in ipairs(payload.blocks) do
            local kind = type(raw) == 'table' and raw.type or nil
            local template = kind and Defaults.Block[kind]
            if template then
                local block = Kaos.DeepCopy(template)
                for k, v in pairs(raw) do
                    if block[k] ~= nil and k ~= 'type' then block[k] = v end
                end
                if kind == 'icon' and type(raw.emoji) == 'string' and raw.emoji ~= '' then
                    block.emoji = raw.emoji
                    block.glyph = ''
                end
                card.blocks[#card.blocks + 1] = block
            end
        end
    end

    if #card.blocks == 0 then return nil end
    return Kaos.SanitiseCard(card)
end

--- cb(ok, cardOrError)
function AI.Generate(src, prompt, cb)
    if not Config.AI.enabled then return cb(false, 'disabled') end

    local key = getKey()
    if not key then return cb(false, 'nokey') end

    local now = os.time()
    if cooldowns[src] and now - cooldowns[src] < Config.AI.cooldownSeconds then
        return cb(false, 'cooldown')
    end
    cooldowns[src] = now

    prompt = Kaos.Trim(prompt or ''):sub(1, Config.AI.maxPromptLength)
    if prompt == '' then return cb(false, 'empty') end

    local url = (Config.AI.endpoint):format(Config.AI.model) .. '?key=' .. key

    local body = json.encode({
        systemInstruction = { parts = { { text = SYSTEM_PROMPT } } },
        contents = { {
            role = 'user',
            parts = { { text = 'Design this card: ' .. prompt } }
        } },
        generationConfig = {
            temperature = 0.85,
            topP = 0.95,
            maxOutputTokens = 1600,
            responseMimeType = 'application/json',
        },
        safetySettings = {
            { category = 'HARM_CATEGORY_HARASSMENT', threshold = 'BLOCK_ONLY_HIGH' },
            { category = 'HARM_CATEGORY_HATE_SPEECH', threshold = 'BLOCK_ONLY_HIGH' },
            { category = 'HARM_CATEGORY_SEXUALLY_EXPLICIT', threshold = 'BLOCK_ONLY_HIGH' },
            { category = 'HARM_CATEGORY_DANGEROUS_CONTENT', threshold = 'BLOCK_ONLY_HIGH' },
        },
    })

    PerformHttpRequest(url, function(status, response)
        if status ~= 200 or not response then
            Kaos.Warn(('gemini http %s: %s'):format(status, tostring(response):sub(1, 300)))
            return cb(false, 'http')
        end

        local ok, decoded = pcall(json.decode, response)
        if not ok or type(decoded) ~= 'table' then return cb(false, 'decode') end

        local candidate = decoded.candidates and decoded.candidates[1]
        local text = candidate and candidate.content and candidate.content.parts
            and candidate.content.parts[1] and candidate.content.parts[1].text

        if type(text) ~= 'string' then return cb(false, 'empty') end

        local parsedOk, payload = pcall(json.decode, stripFence(text))
        if not parsedOk then return cb(false, 'parse') end

        local card = buildCard(payload)
        if not card then return cb(false, 'shape') end

        cb(true, card)
    end, 'POST', body, { ['Content-Type'] = 'application/json' })
end

AddEventHandler('playerDropped', function()
    cooldowns[source] = nil
end)

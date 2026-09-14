Kaos = Kaos or {}

function Kaos.Print(...)
    local parts = { ... }
    for i = 1, #parts do parts[i] = tostring(parts[i]) end
    print(('^5[kaos]^7 %s'):format(table.concat(parts, ' ')))
end

function Kaos.Warn(...)
    local parts = { ... }
    for i = 1, #parts do parts[i] = tostring(parts[i]) end
    print(('^3[kaos]^7 %s'):format(table.concat(parts, ' ')))
end

function Kaos.Uuid()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx'
    return (template:gsub('[xy]', function(c)
        local v = (c == 'x') and math.random(0, 15) or math.random(8, 11)
        return ('%x'):format(v)
    end))
end

function Kaos.Clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

function Kaos.Round(v, places)
    local mult = 10 ^ (places or 0)
    return math.floor(v * mult + 0.5) / mult
end

function Kaos.DeepCopy(tbl)
    if type(tbl) ~= 'table' then return tbl end
    local out = {}
    for k, v in pairs(tbl) do out[k] = Kaos.DeepCopy(v) end
    return out
end

-- Fills missing keys of `target` from `source`, recursively.
function Kaos.Defaults(target, source)
    if type(target) ~= 'table' then return Kaos.DeepCopy(source) end
    for k, v in pairs(source) do
        if type(v) == 'table' then
            target[k] = Kaos.Defaults(target[k], v)
        elseif target[k] == nil then
            target[k] = v
        end
    end
    return target
end

function Kaos.Trim(s)
    if type(s) ~= 'string' then return '' end
    return (s:gsub('^%s*(.-)%s*$', '%1'))
end

function Kaos.StartsWith(s, prefix)
    return type(s) == 'string' and s:sub(1, #prefix) == prefix
end

function Kaos.IsBlockedCommand(cmd)
    if type(cmd) ~= 'string' then return true end
    local first = cmd:match('^%s*([%w_]+)')
    if not first then return true end
    first = first:lower()
    for _, blocked in ipairs(Config.BlockedCommands) do
        if first == blocked:lower() then return true end
    end
    return false
end

-- Sanitises a card record coming from a client before it is trusted.
function Kaos.SanitiseCard(card)
    if type(card) ~= 'table' then return nil end
    card = Kaos.Defaults(card, Defaults.Card)

    if type(card.id) ~= 'string' or #card.id < 4 then card.id = Kaos.Uuid() end
    if type(card.name) ~= 'string' or card.name == '' then card.name = 'Untitled float' end
    card.name = card.name:sub(1, 64)

    if type(card.blocks) ~= 'table' then card.blocks = {} end
    if #card.blocks > 24 then
        for i = #card.blocks, 25, -1 do card.blocks[i] = nil end
    end

    for _, block in ipairs(card.blocks) do
        if type(block.text) == 'string' then block.text = block.text:sub(1, 400) end
    end

    local interact = card.rules and card.rules.interact
    if interact and interact.on then
        if interact.action == 'command' and Kaos.IsBlockedCommand(interact.payload) then
            interact.on = false
            interact.payload = ''
        end
        interact.radius = Kaos.Clamp(tonumber(interact.radius) or 2.0, 0.5, 15.0)
    end

    card.rules.distance = Kaos.Clamp(tonumber(card.rules.distance) or 60.0, 1.0, 500.0)
    card.rules.fade = Kaos.Clamp(tonumber(card.rules.fade) or 12.0, 0.0, 200.0)

    return card
end

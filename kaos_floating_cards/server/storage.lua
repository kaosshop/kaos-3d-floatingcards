Storage = {
    cards = {},     -- id -> card
    presets = {},   -- kind -> { [name] = data }
    dirty = false,
}

local RESOURCE = GetCurrentResourceName()

local function readJson(path)
    local raw = LoadResourceFile(RESOURCE, path)
    if not raw or raw == '' then return nil end
    local ok, decoded = pcall(json.decode, raw)
    if not ok then
        Kaos.Warn(('%s is not valid JSON, ignoring it.'):format(path))
        return nil
    end
    return decoded
end

local function writeJson(path, data)
    return SaveResourceFile(RESOURCE, path, json.encode(data, { indent = true }), -1)
end

function Storage.Load()
    local data = readJson(Config.Storage.file)
    if type(data) == 'table' then
        local list = data.cards or data
        for _, card in pairs(list) do
            local clean = Kaos.SanitiseCard(card)
            if clean then Storage.cards[clean.id] = clean end
        end
    end

    local presets = readJson(Config.Storage.presetsFile)
    Storage.presets = type(presets) == 'table' and presets or
        { style = {}, motion = {}, effects = {}, place = {}, card = {} }

    local count = 0
    for _ in pairs(Storage.cards) do count = count + 1 end
    Kaos.Print(('loaded %d float(s)'):format(count))
end

function Storage.Flush()
    if Config.Storage.backups then
        local current = LoadResourceFile(RESOURCE, Config.Storage.file)
        if current and current ~= '' then
            SaveResourceFile(RESOURCE, 'data/floats.backup.json', current, -1)
        end
    end

    local list = {}
    for _, card in pairs(Storage.cards) do list[#list + 1] = card end
    table.sort(list, function(a, b) return (a.created or 0) < (b.created or 0) end)

    writeJson(Config.Storage.file, { version = 1, cards = list })
    Storage.dirty = false
end

function Storage.FlushPresets()
    writeJson(Config.Storage.presetsFile, Storage.presets)
end

function Storage.List()
    local list = {}
    for _, card in pairs(Storage.cards) do list[#list + 1] = card end
    table.sort(list, function(a, b) return (a.created or 0) < (b.created or 0) end)
    return list
end

function Storage.Upsert(card)
    local clean = Kaos.SanitiseCard(card)
    if not clean then return nil end

    local existing = Storage.cards[clean.id]
    clean.created = existing and existing.created or os.time()
    clean.updated = os.time()

    Storage.cards[clean.id] = clean
    Storage.Flush()
    return clean
end

function Storage.Remove(id)
    if not Storage.cards[id] then return false end
    Storage.cards[id] = nil
    Storage.Flush()
    return true
end

function Storage.SavePreset(kind, name, data)
    Storage.presets[kind] = Storage.presets[kind] or {}
    Storage.presets[kind][name] = data
    Storage.FlushPresets()
end

function Storage.DeletePreset(kind, name)
    if Storage.presets[kind] then Storage.presets[kind][name] = nil end
    Storage.FlushPresets()
end

if Config.Storage.autosaveSeconds and Config.Storage.autosaveSeconds > 0 then
    CreateThread(function()
        while true do
            Wait(Config.Storage.autosaveSeconds * 1000)
            if Storage.dirty then Storage.Flush() end
        end
    end)
end

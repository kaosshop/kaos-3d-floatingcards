local function notify(src, key)
    TriggerClientEvent('kaos:notify', src, key)
end

CreateThread(function()
    Storage.Load()
end)

-- ── Sync ────────────────────────────────────────────────────────
local function broadcast()
    TriggerClientEvent('kaos:sync', -1, Storage.List())
end

RegisterNetEvent('kaos:requestSync', function()
    local src = source
    TriggerClientEvent('kaos:sync', src, Storage.List())
    TriggerClientEvent('kaos:session', src, {
        canEdit = Permissions.CanEdit(src),
        framework = Permissions.GetFramework(),
        player = Permissions.GetPlayerInfo(src),
        aiEnabled = Config.AI.enabled,
        presets = Storage.presets,
    })
end)

-- ── Mutations ───────────────────────────────────────────────────
RegisterNetEvent('kaos:save', function(card)
    local src = source
    if not Permissions.CanEdit(src) then return notify(src, 'noAccess') end

    local saved = Storage.Upsert(card)
    if not saved then return end

    broadcast()
    TriggerClientEvent('kaos:saved', src, saved)
end)

RegisterNetEvent('kaos:delete', function(id)
    local src = source
    if not Permissions.CanEdit(src) then return notify(src, 'noAccess') end
    if type(id) ~= 'string' then return end

    if Storage.Remove(id) then
        broadcast()
        TriggerClientEvent('kaos:deleted', src, id)
    end
end)

RegisterNetEvent('kaos:duplicate', function(id)
    local src = source
    if not Permissions.CanEdit(src) then return notify(src, 'noAccess') end

    local original = Storage.cards[id]
    if not original then return end

    local copy = Kaos.DeepCopy(original)
    copy.id = Kaos.Uuid()
    copy.name = (original.name .. ' copy'):sub(1, 64)
    copy.anchor.pos.x = copy.anchor.pos.x + 1.0

    local saved = Storage.Upsert(copy)
    broadcast()
    TriggerClientEvent('kaos:saved', src, saved)
end)

RegisterNetEvent('kaos:toggle', function(id, enabled)
    local src = source
    if not Permissions.CanEdit(src) then return notify(src, 'noAccess') end

    local card = Storage.cards[id]
    if not card then return end

    card.enabled = enabled and true or false
    card.updated = os.time()
    Storage.Flush()
    broadcast()
end)

-- ── Presets ─────────────────────────────────────────────────────
RegisterNetEvent('kaos:savePreset', function(kind, name, data)
    local src = source
    if not Permissions.CanEdit(src) then return notify(src, 'noAccess') end
    if type(kind) ~= 'string' or type(name) ~= 'string' or name == '' then return end

    Storage.SavePreset(kind, name:sub(1, 40), data)
    TriggerClientEvent('kaos:presets', -1, Storage.presets)
end)

RegisterNetEvent('kaos:deletePreset', function(kind, name)
    local src = source
    if not Permissions.CanEdit(src) then return notify(src, 'noAccess') end

    Storage.DeletePreset(kind, name)
    TriggerClientEvent('kaos:presets', -1, Storage.presets)
end)

-- ── Import / export ─────────────────────────────────────────────
RegisterNetEvent('kaos:import', function(payload)
    local src = source
    if not Permissions.CanEdit(src) then return notify(src, 'noAccess') end
    if type(payload) ~= 'table' then return end

    local list = payload.cards or payload
    local added = 0

    for _, raw in pairs(list) do
        if type(raw) == 'table' then
            raw.id = Kaos.Uuid()
            if Storage.Upsert(raw) then added = added + 1 end
        end
    end

    broadcast()
    TriggerClientEvent('kaos:imported', src, added)
end)

-- ── AI ──────────────────────────────────────────────────────────
RegisterNetEvent('kaos:ai', function(prompt)
    local src = source
    if not Permissions.CanEdit(src) then return notify(src, 'noAccess') end

    AI.Generate(src, prompt, function(ok, result)
        if ok then
            TriggerClientEvent('kaos:aiResult', src, result)
        else
            TriggerClientEvent('kaos:aiError', src, result)
        end
    end)
end)

-- ── Interaction relay ───────────────────────────────────────────
RegisterNetEvent('kaos:interact', function(id)
    local src = source
    local card = Storage.cards[id]
    if not card then return end

    local interact = card.rules and card.rules.interact
    if not interact or not interact.on then return end

    if interact.action == 'command' then
        if Kaos.IsBlockedCommand(interact.payload) then return end
        ExecuteCommand(('%s %d'):format(interact.payload, src))
    elseif interact.action == 'server' then
        if interact.payload ~= '' then
            TriggerEvent(interact.payload, src, card.id)
        end
    end
end)

-- ── Exports for other resources ─────────────────────────────────
exports('getFloats', function()
    return Storage.List()
end)

exports('getFloat', function(id)
    return Storage.cards[id]
end)

exports('createFloat', function(card)
    local saved = Storage.Upsert(card)
    if saved then broadcast() end
    return saved
end)

exports('updateFloat', function(id, patch)
    local card = Storage.cards[id]
    if not card or type(patch) ~= 'table' then return nil end

    for k, v in pairs(patch) do card[k] = v end
    local saved = Storage.Upsert(card)
    broadcast()
    return saved
end)

exports('deleteFloat', function(id)
    local removed = Storage.Remove(id)
    if removed then broadcast() end
    return removed
end)

-- ── Admin command ───────────────────────────────────────────────
RegisterCommand('kaosreload', function(src)
    if src ~= 0 and not Permissions.CanEdit(src) then return end
    Storage.cards = {}
    Storage.Load()
    broadcast()
    Kaos.Print('reloaded from disk')
end, false)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() and Storage.dirty then
        Storage.Flush()
    end
end)

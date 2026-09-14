-- "Players can interact" support: hold the key near a card to fire its action.

Interact = {}

local keyCodes = {
    E = 38, F = 23, G = 47, H = 74, X = 73, Z = 20,
    ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165,
}

local function nearest()
    local best, bestDist
    for id, live in pairs(State.active) do
        local card = State.Live(id)
        local rules = card and card.rules and card.rules.interact
        if rules and rules.on and live.dist <= (rules.radius or 2.0) then
            if not bestDist or live.dist < bestDist then
                best, bestDist = card, live.dist
            end
        end
    end
    return best
end

CreateThread(function()
    while true do
        local wait = 400
        if State.ready and not State.open then
            local card = nearest()
            if card then
                wait = 0
                local it = card.rules.interact
                local code = keyCodes[(it.key or 'E'):upper()] or 38
                if IsControlJustReleased(0, code) then
                    TriggerServerEvent('kaos:interact', card.id)
                    Wait(400)
                end
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent('kaos:runClient', function(event, payload)
    if type(event) ~= 'string' or event == '' then return end
    TriggerEvent(event, payload)
end)

RegisterNetEvent('kaos:notify', function(message)
    SendNUIMessage({ action = 'toast', text = tostring(message) })
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(tostring(message))
    EndTextCommandThefeedPostTicker(false, true)
end)

-- Card projection loop.
-- The cards themselves are DOM nodes living in the NUI page; this file only
-- decides where on the screen each one belongs, how big, and how visible.

Render = {}

local scanned = {}          -- ids that passed the coarse distance scan
local born = {}             -- id -> game time the card entered range (appear anim)
local screenW, screenH = 1920.0, 1080.0
local clock = 0.0

local function resolveAnchor(card)
    local a = card.anchor
    local base

    if a.mode == 'me' then
        base = GetEntityCoords(PlayerPedId())
    elseif a.mode == 'entity' then
        local ent = a.entity ~= 0 and NetworkDoesNetworkIdExist(a.entity) and NetworkGetEntityFromNetworkId(a.entity) or 0
        if ent == 0 or not DoesEntityExist(ent) then return nil end
        if a.bone ~= '' then
            local idx = GetEntityBoneIndexByName(ent, a.bone)
            if idx ~= -1 then base = GetWorldPositionOfEntityBone(ent, idx) end
        end
        base = base or GetEntityCoords(ent)
    elseif a.mode == 'plate' then
        local veh = Render.FindPlate(a.plate)
        if not veh then return nil end
        base = GetEntityCoords(veh)
    else
        base = vector3(a.pos.x + 0.0, a.pos.y + 0.0, a.pos.z + 0.0)
    end

    return base + vector3(a.offset.x + 0.0, a.offset.y + 0.0, a.offset.z + 0.0)
end

function Render.FindPlate(plate)
    if not plate or plate == '' then return nil end
    local want = plate:gsub('%s+', ''):upper()
    for _, veh in ipairs(GetGamePool('CVehicle')) do
        if GetVehicleNumberPlateText(veh):gsub('%s+', ''):upper() == want then return veh end
    end
    return nil
end

local function hoursOk(rules)
    local from, to = rules.hours.from or 0, rules.hours.to or 24
    if from == 0 and to >= 24 then return true end
    local hour = GetClockHours()
    if from <= to then return hour >= from and hour < to end
    return hour >= from or hour < to
end

local function listHas(list, value)
    if not list or #list == 0 then return true end
    for _, item in ipairs(list) do
        if item == value then return true end
    end
    return false
end

--- Rules that do not depend on the camera, checked on the slow scan.
local function passesRules(card)
    if not card.enabled then return false end
    local rules = card.rules
    local job = Framework.job
    if rules.jobs and #rules.jobs > 0 and not listHas(rules.jobs, job) then return false end
    if rules.groups and #rules.groups > 0 then
        if not (listHas(rules.groups, Framework.group) or State.canEdit) then return false end
    end
    if not hoursOk(rules) then return false end
    return true
end

-- ── coarse scan ─────────────────────────────────────────────────
CreateThread(function()
    while true do
        local wait = Config.Render.scanInterval
        if State.ready then
            local ped = PlayerPedId()
            local me = GetEntityCoords(ped)
            local found = {}

            for _, card in ipairs(State.List()) do
                local editing = State.open and State.selectedId == card.id
                if (State.visible or editing) and (passesRules(card) or editing) then
                    local pos = resolveAnchor(card)
                    if pos then
                        local dist = #(me - pos)
                        local limit = math.min(card.rules.distance or Config.Render.defaultDistance, 500.0)
                        if editing then limit = math.max(limit, 500.0) end
                        if dist <= limit then
                            found[#found + 1] = { id = card.id, dist = dist }
                        end
                    end
                end
            end

            table.sort(found, function(a, b) return a.dist < b.dist end)
            scanned = {}
            for i = 1, math.min(#found, Config.Render.maxActiveCards) do
                scanned[#scanned + 1] = found[i].id
            end
        else
            wait = 250
        end
        Wait(wait)
    end
end)

-- ── per frame projection ────────────────────────────────────────
local function motionOffset(card, dist)
    local m, t = card.motion, clock
    local ox, oy, oz, yaw, scale, alpha = 0.0, 0.0, 0.0, 0.0, 1.0, 1.0

    if m.bob.on then
        oz = oz + math.sin(t * (m.bob.speed or 1.0) * 1.8) * (m.bob.amount or 0.06)
    end
    if m.orbit.on then
        local a = t * (m.orbit.speed or 0.7)
        ox = ox + math.cos(a) * (m.orbit.radius or 0.35)
        oy = oy + math.sin(a) * (m.orbit.radius or 0.35)
    end
    if m.pulse.on then
        scale = scale + math.sin(t * (m.pulse.speed or 1.0) * 2.2) * (m.pulse.amount or 0.05)
    end
    if m.sway.on then
        yaw = yaw + math.sin(t * (m.sway.speed or 1.0) * 1.2) * (m.sway.amount or 4.0)
    end
    if m.spin.on then
        yaw = yaw + (t * (m.spin.speed or 0.4) * 90.0) % 360.0
    end
    if m.flicker.on then
        local n = math.sin(t * 17.0 * (m.flicker.speed or 1.0)) * math.sin(t * 5.3)
        if n > 0.62 then alpha = alpha * (1.0 - (m.flicker.amount or 0.4)) end
    end

    return ox, oy, oz, yaw, scale, alpha
end

local function appearAlpha(card, id)
    local mode = card.motion.appear and card.motion.appear.mode or 'fade'
    if mode == 'none' then return 1.0, 0.0, 1.0 end
    local start = born[id]
    if not start then born[id] = GetGameTimer(); start = born[id] end
    local dur = math.max((card.motion.appear.duration or 0.35) * 1000.0, 1.0)
    local k = math.min((GetGameTimer() - start) / dur, 1.0)
    local eased = 1.0 - (1.0 - k) * (1.0 - k) * (1.0 - k)
    if mode == 'rise' then return eased, (1.0 - eased) * 40.0, 1.0 end
    if mode == 'pop'  then return eased, 0.0, 0.86 + eased * 0.14 end
    return eased, 0.0, 1.0
end

CreateThread(function()
    while true do
        if State.ready and #scanned > 0 then
            screenW, screenH = GetActiveScreenResolution()
            clock = GetGameTimer() / 1000.0

            local camPos = GetGameplayCamCoord()
            if State.freecam then camPos = Freecam.Position() or camPos end
            local camRot = GetGameplayCamRot(2)
            local fov = math.rad(GetGameplayCamFov())
            local half = math.tan(fov * 0.5)
            local ped = PlayerPedId()
            local me = GetEntityCoords(ped)

            local payload, seen = {}, {}

            for _, id in ipairs(scanned) do
                local card = State.Live(id)
                if card then
                    local pos = resolveAnchor(card)
                    if pos then
                        local ox, oy, oz, mYaw, mScale, mAlpha = motionOffset(card, 0)
                        pos = pos + vector3(ox, oy, oz)

                        local dist = #(camPos - pos)
                        local playerDist = #(me - pos)
                        local editing = State.open and State.selectedId == card.id

                        local limit = card.rules.distance or Config.Render.defaultDistance
                        local fade = math.min(card.rules.fade or Config.Render.fadeBand, limit)
                        local alpha = mAlpha

                        if not editing then
                            if playerDist > limit then alpha = 0.0
                            elseif fade > 0.0 and playerDist > (limit - fade) then
                                alpha = alpha * (1.0 - (playerDist - (limit - fade)) / fade)
                            end
                            if (card.rules.hideCloserThan or 0.0) > 0.0 and playerDist < card.rules.hideCloserThan then
                                alpha = 0.0
                            end
                            if card.rules.hideBehindWalls and Config.Render.occlusionChecks then
                                local ray = StartShapeTestRay(camPos.x, camPos.y, camPos.z, pos.x, pos.y, pos.z, 1, ped, 0)
                                local _, hit = GetShapeTestResult(ray)
                                if hit == 1 then alpha = 0.0 end
                            end
                        end

                        local aAlpha, aRise, aScale = appearAlpha(card, id)
                        alpha = alpha * aAlpha

                        if alpha > 0.01 then
                            local ok, sx, sy = World3dToScreen2d(pos.x, pos.y, pos.z)
                            if ok then
                                local pxW, pxH = State.Size(id)
                                local scale

                                if card.size.mode == 'screen' then
                                    scale = card.size.scale or 1.0
                                else
                                    local metres = (pxH / State.PIXELS_PER_METRE) * (card.size.scale or 1.0)
                                    local onScreen = metres * (screenH / (2.0 * math.max(dist, 0.35) * half))
                                    scale = onScreen / math.max(pxH, 1.0)
                                end

                                local shownH = pxH * scale
                                if shownH < (card.size.minPx or 40) then scale = (card.size.minPx or 40) / pxH end
                                if shownH > (card.size.maxPx or 900) then scale = (card.size.maxPx or 900) / pxH end
                                scale = scale * mScale * aScale

                                local yaw = mYaw
                                local show = true
                                if card.facing.mode ~= 'camera' then
                                    local toCam = camPos - pos
                                    local camHeading = math.deg(math.atan(toCam.y, toCam.x)) - 90.0
                                    local delta = ((card.facing.heading or 0.0) - camHeading + 540.0) % 360.0 - 180.0
                                    yaw = yaw + delta
                                    if math.abs(delta) > 88.0 and not card.facing.readableFromBehind then
                                        show = math.abs(delta) < 92.0
                                        alpha = alpha * math.max(0.0, (92.0 - math.abs(delta)) / 4.0)
                                    end
                                end

                                if show and alpha > 0.01 then
                                    seen[id] = true
                                    State.active[id] = { dist = playerDist, x = sx, y = sy, scale = scale, alpha = alpha }
                                    payload[#payload + 1] = {
                                        id = id,
                                        x = sx * screenW,
                                        y = sy * screenH + aRise,
                                        s = scale,
                                        a = alpha,
                                        r = yaw,
                                        p = card.facing.mode == 'fixed' and (card.facing.pitch or 0.0) or 0.0,
                                        near = playerDist <= 8.0,
                                        sel = editing,
                                        d = playerDist,
                                    }
                                    Effects.Draw(card, pos, alpha, clock)
                                end
                            end
                        end
                    end
                end
            end

            for id in pairs(State.active) do
                if not seen[id] then State.active[id] = nil; born[id] = nil end
            end

            SendNUIMessage({ action = 'project', cards = payload, w = screenW, h = screenH })
        end
        Wait(0)
    end
end)

--- Pushes the full card list into the NUI so it can build the DOM nodes.
function Render.Sync()
    SendNUIMessage({
        action = 'cards',
        cards = State.List(),
        visible = State.visible,
        selected = State.selectedId,
    })
end

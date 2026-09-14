-- Move / rotate handles for the selected float.
-- The NUI owns the cursor, so it forwards raw mouse events to us.

Gizmo = {}

local axes = {
    { key = 'x', dir = vector3(1.0, 0.0, 0.0), r = 235, g = 64,  b = 64  },
    { key = 'y', dir = vector3(0.0, 1.0, 0.0), r = 74,  g = 222, b = 128 },
    { key = 'z', dir = vector3(0.0, 0.0, 1.0), r = 96,  g = 165, b = 250 },
}

local handles = {}          -- key -> { x, y, ox, oy } in pixels
local drag = nil
local cursor = { x = 0, y = 0 }

local function anchorPos(card)
    local a = card.anchor
    if a.mode == 'world' then
        return vector3(a.pos.x + a.offset.x, a.pos.y + a.offset.y, a.pos.z + a.offset.z)
    end
    if a.mode == 'me' then
        return GetEntityCoords(PlayerPedId()) + vector3(a.offset.x, a.offset.y, a.offset.z)
    end
    if a.mode == 'entity' and a.entity ~= 0 and NetworkDoesNetworkIdExist(a.entity) then
        local ent = NetworkGetEntityFromNetworkId(a.entity)
        if DoesEntityExist(ent) then
            return GetEntityCoords(ent) + vector3(a.offset.x, a.offset.y, a.offset.z)
        end
    end
    if a.mode == 'plate' then
        local veh = Render.FindPlate(a.plate)
        if veh then return GetEntityCoords(veh) + vector3(a.offset.x, a.offset.y, a.offset.z) end
    end
    return nil
end

local function pixels(pos)
    local ok, sx, sy = World3dToScreen2d(pos.x, pos.y, pos.z)
    if not ok then return nil end
    local w, h = GetActiveScreenResolution()
    return sx * w, sy * h
end

local function distanceToSegment(px, py, ax, ay, bx, by)
    local dx, dy = bx - ax, by - ay
    local len = dx * dx + dy * dy
    if len <= 0.0001 then return math.sqrt((px - ax) ^ 2 + (py - ay) ^ 2) end
    local t = math.max(0.0, math.min(1.0, ((px - ax) * dx + (py - ay) * dy) / len))
    local qx, qy = ax + dx * t, ay + dy * t
    return math.sqrt((px - qx) ^ 2 + (py - qy) ^ 2)
end

--- Writes the moved position back onto the draft, respecting the anchor mode.
local function applyDelta(dx, dy, dz)
    local card = State.draft
    if not card then return end
    if card.anchor.mode == 'world' then
        card.anchor.pos.x = Kaos.Round(card.anchor.pos.x + dx, 2)
        card.anchor.pos.y = Kaos.Round(card.anchor.pos.y + dy, 2)
        card.anchor.pos.z = Kaos.Round(card.anchor.pos.z + dz, 2)
    else
        card.anchor.offset.x = Kaos.Round(card.anchor.offset.x + dx, 2)
        card.anchor.offset.y = Kaos.Round(card.anchor.offset.y + dy, 2)
        card.anchor.offset.z = Kaos.Round(card.anchor.offset.z + dz, 2)
    end
    SendNUIMessage({ action = 'anchor', anchor = card.anchor, facing = card.facing })
end

function Gizmo.Mouse(kind, x, y, button)
    cursor.x, cursor.y = x or 0, y or 0
    if not State.draft or State.gizmoMode == 'off' then drag = nil; return false end

    if kind == 'down' and button == 0 then
        local best, bestDist
        for key, h in pairs(handles) do
            local d = distanceToSegment(cursor.x, cursor.y, h.ox, h.oy, h.x, h.y)
            if d < 24 and (not bestDist or d < bestDist) then best, bestDist = key, d end
        end
        if best then
            drag = { axis = best, x = cursor.x, y = cursor.y }
            return true
        end
        return false
    end

    if kind == 'move' and drag then
        local h = handles[drag.axis]
        if h then
            local ux, uy = h.x - h.ox, h.y - h.oy
            local len = math.sqrt(ux * ux + uy * uy)
            if len > 1.0 then
                ux, uy = ux / len, uy / len
                local mx, my = cursor.x - drag.x, cursor.y - drag.y
                local along = (mx * ux + my * uy) / len   -- fraction of one metre

                if State.gizmoMode == 'rotate' then
                    local card = State.draft
                    card.facing.heading = Kaos.Round((card.facing.heading + along * 90.0) % 360.0, 1)
                    if card.facing.mode == 'camera' then card.facing.mode = 'upright' end
                    SendNUIMessage({ action = 'anchor', anchor = card.anchor, facing = card.facing })
                else
                    if drag.axis == 'x' then applyDelta(along, 0.0, 0.0)
                    elseif drag.axis == 'y' then applyDelta(0.0, along, 0.0)
                    else applyDelta(0.0, 0.0, along) end
                end
            end
        end
        drag.x, drag.y = cursor.x, cursor.y
        return true
    end

    if kind == 'up' then
        local was = drag ~= nil
        drag = nil
        return was
    end

    return false
end

function Gizmo.Dragging() return drag ~= nil end

CreateThread(function()
    while true do
        handles = {}
        local card = State.draft
        if State.open and card and State.gizmoMode ~= 'off' then
            local origin = anchorPos(card)
            if origin then
                local camDist = #(GetFinalRenderedCamCoord() - origin)
                local length = Kaos.Clamp(camDist * 0.12, 0.35, 3.0)
                local ox, oy = pixels(origin)
                local labels = {}

                for _, axis in ipairs(axes) do
                    local tip = origin + axis.dir * length
                    local tx, ty = pixels(tip)
                    if ox and tx then
                        handles[axis.key] = { x = tx, y = ty, ox = ox, oy = oy }
                        local hot = (drag and drag.axis == axis.key)
                        local a = hot and 255 or 200
                        DrawLine(origin.x, origin.y, origin.z, tip.x, tip.y, tip.z, axis.r, axis.g, axis.b, a)

                        if State.gizmoMode == 'move' then
                            local rotMarker
                            if axis.key == 'z' then rotMarker = vector3(0.0, 0.0, 0.0)
                            elseif axis.key == 'x' then rotMarker = vector3(0.0, 90.0, 0.0)
                            else rotMarker = vector3(-90.0, 0.0, 0.0) end
                            DrawMarker(0, tip.x, tip.y, tip.z, 0.0, 0.0, 0.0,
                                rotMarker.x, rotMarker.y, rotMarker.z,
                                length * 0.18, length * 0.18, length * 0.28,
                                axis.r, axis.g, axis.b, a, false, false, 2, false, nil, nil, false)
                        else
                            DrawMarker(28, tip.x, tip.y, tip.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                                length * 0.09, length * 0.09, length * 0.09,
                                axis.r, axis.g, axis.b, a, false, false, 2, false, nil, nil, false)
                        end

                        labels[#labels + 1] = { axis = axis.key:upper(), x = tx, y = ty, hot = hot }
                    end
                end

                DrawMarker(28, origin.x, origin.y, origin.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    length * 0.07, length * 0.07, length * 0.07, 235, 64, 64, 220,
                    false, false, 2, false, nil, nil, false)

                SendNUIMessage({ action = 'gizmo', labels = labels, mode = State.gizmoMode })
            end
            Wait(0)
        else
            SendNUIMessage({ action = 'gizmo', labels = {} })
            Wait(250)
        end
    end
end)

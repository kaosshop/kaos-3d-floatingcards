-- Ground and light effects. These are drawn with engine natives rather than
-- DOM so they sit in the world properly and respect depth.

Effects = {}

local function hex(value, fallback)
    local s = (value or ''):gsub('#', '')
    if #s < 6 then s = (fallback or 'FFFFFF') end
    return tonumber(s:sub(1, 2), 16) or 255,
           tonumber(s:sub(3, 4), 16) or 255,
           tonumber(s:sub(5, 6), 16) or 255
end

local function groundBelow(pos)
    local ok, z = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z + 1.0, false)
    if ok then return z end
    return pos.z - 1.0
end

function Effects.Draw(card, pos, alpha, clock)
    local fx = card.effects
    if not fx then return end
    if not (fx.beam.on or fx.ring.on or fx.tether.on or fx.shadow.on) then return end

    local groundZ = groundBelow(pos)

    if fx.beam.on then
        local r, g, b = hex(fx.beam.color, 'FFFFFF')
        local a = math.floor(255 * (fx.beam.opacity or 0.18) * alpha)
        local h = fx.beam.height or 1.4
        local rad = fx.beam.radius or 0.35
        DrawMarker(1, pos.x, pos.y, groundZ, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            rad * 2.0, rad * 2.0, h, r, g, b, a, false, false, 2, false, nil, nil, false)
    end

    if fx.ring.on then
        local r, g, b = hex(fx.ring.color, 'FFFFFF')
        local a = math.floor(255 * (fx.ring.opacity or 0.35) * alpha)
        local pulse = 1.0 + math.sin(clock * (fx.ring.speed or 0.6) * 2.0) * 0.06
        local rad = (fx.ring.radius or 0.6) * pulse
        DrawMarker(25, pos.x, pos.y, groundZ + 0.03, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            rad * 2.0, rad * 2.0, 1.0, r, g, b, a, false, false, 2, false, nil, nil, false)
    end

    if fx.tether.on then
        local r, g, b = hex(fx.tether.color, 'FFFFFF')
        local a = math.floor(255 * (fx.tether.opacity or 0.35) * alpha)
        DrawLine(pos.x, pos.y, pos.z, pos.x, pos.y, groundZ, r, g, b, a)
    end

    if fx.shadow.on then
        local a = math.floor(255 * (fx.shadow.opacity or 0.3) * alpha)
        local rad = fx.shadow.radius or 0.5
        DrawMarker(28, pos.x, pos.y, groundZ + 0.02, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            rad, rad, 0.02, 0, 0, 0, a, false, false, 2, false, nil, nil, false)
    end
end

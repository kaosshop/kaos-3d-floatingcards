-- Studio camera. The NUI owns the keyboard and mouse while the panels are up,
-- so movement arrives here as forwarded key state and pointer-lock deltas.

Freecam = {}

local cam = nil
local pos = vector3(0.0, 0.0, 0.0)
local rot = vector3(0.0, 0.0, 0.0)
local keys = {}
local looking = false
local sensitivity = 0.12

function Freecam.Active() return cam ~= nil end
function Freecam.Position() return cam and pos or nil end

function Freecam.Start()
    if cam then return end
    local base = GetGameplayCamCoord()
    local baseRot = GetGameplayCamRot(2)
    pos = base
    rot = vector3(baseRot.x, 0.0, baseRot.z)

    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(cam, pos.x, pos.y, pos.z)
    SetCamRot(cam, rot.x, 0.0, rot.z, 2)
    SetCamFov(cam, GetGameplayCamFov())
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 400, true, false)
    State.freecam = true
end

function Freecam.Stop()
    if not cam then return end
    RenderScriptCams(false, true, 400, true, false)
    DestroyCam(cam, false)
    cam = nil
    keys = {}
    looking = false
    State.freecam = false
end

function Freecam.SetKeys(next)
    keys = next or {}
end

function Freecam.SetLooking(on)
    looking = on and true or false
    if not on then keys = {} end
end

function Freecam.Look(dx, dy)
    if not cam or not looking then return end
    local z = rot.z - (dx or 0.0) * sensitivity
    local x = Kaos.Clamp(rot.x - (dy or 0.0) * sensitivity, -89.0, 89.0)
    rot = vector3(x, 0.0, z % 360.0)
end

--- Where the middle of the studio camera is pointing, for "place with the reticle".
function Freecam.Raycast(maxDistance)
    local origin = cam and pos or GetGameplayCamCoord()
    local dir
    if cam then
        local rx, rz = math.rad(rot.x), math.rad(rot.z)
        local cosx = math.cos(rx)
        dir = vector3(-math.sin(rz) * math.abs(cosx), math.cos(rz) * math.abs(cosx), math.sin(rx))
    else
        local r = GetGameplayCamRot(2)
        local rx, rz = math.rad(r.x), math.rad(r.z)
        local cosx = math.cos(rx)
        dir = vector3(-math.sin(rz) * math.abs(cosx), math.cos(rz) * math.abs(cosx), math.sin(rx))
    end

    local target = origin + dir * (maxDistance or 30.0)
    local ray = StartShapeTestRay(origin.x, origin.y, origin.z, target.x, target.y, target.z, -1, PlayerPedId(), 0)
    local _, hit, coords = GetShapeTestResult(ray)
    if hit == 1 then return coords end
    return target
end

CreateThread(function()
    while true do
        if cam then
            local speed = Config.Studio.freecamSpeed or 1.0
            if keys.shift then speed = speed * 4.0 end
            if keys.alt then speed = speed * 0.25 end
            speed = speed * 0.22

            local rz = math.rad(rot.z)
            local rx = math.rad(rot.x)
            local forward = vector3(-math.sin(rz) * math.abs(math.cos(rx)), math.cos(rz) * math.abs(math.cos(rx)), math.sin(rx))
            local right = vector3(math.cos(rz), math.sin(rz), 0.0)

            local move = vector3(0.0, 0.0, 0.0)
            if keys.w then move = move + forward end
            if keys.s then move = move - forward end
            if keys.d then move = move + right end
            if keys.a then move = move - right end
            if keys.e then move = move + vector3(0.0, 0.0, 1.0) end
            if keys.q then move = move - vector3(0.0, 0.0, 1.0) end

            if #move > 0.0 then pos = pos + move * speed end

            SetCamCoord(cam, pos.x, pos.y, pos.z)
            SetCamRot(cam, rot.x, 0.0, rot.z, 2)
            SetEntityCoordsNoOffset(PlayerPedId(), pos.x, pos.y, pos.z - 0.5, true, true, true)
            SetEntityVisible(PlayerPedId(), false, false)
            SetEntityCollision(PlayerPedId(), false, false)
            FreezeEntityPosition(PlayerPedId(), true)
            SetEntityInvincible(PlayerPedId(), true)
            Wait(0)
        else
            local ped = PlayerPedId()
            if not IsEntityVisible(ped) and not State.open then
                SetEntityVisible(ped, true, false)
                SetEntityCollision(ped, true, true)
                FreezeEntityPosition(ped, false)
                SetEntityInvincible(ped, false)
            end
            Wait(200)
        end
    end
end)

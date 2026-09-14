Permissions = {}

local Framework = { name = 'standalone', object = nil }

CreateThread(function()
    Wait(500)
    local want = Config.Framework

    local function has(res)
        return GetResourceState(res) == 'started'
    end

    if want == 'auto' or want == 'qbox' then
        if has('qbx_core') then
            Framework.name = 'qbox'
            return Kaos.Print('framework: qbox')
        end
    end
    if want == 'auto' or want == 'qb' then
        if has('qb-core') then
            Framework.name = 'qb'
            Framework.object = exports['qb-core']:GetCoreObject()
            return Kaos.Print('framework: qb-core')
        end
    end
    if want == 'auto' or want == 'esx' then
        if has('es_extended') then
            Framework.name = 'esx'
            Framework.object = exports['es_extended']:getSharedObject()
            return Kaos.Print('framework: esx')
        end
    end

    Kaos.Print('framework: standalone')
end)

function Permissions.GetFramework()
    return Framework.name
end

-- Returns { job = string, grade = number, group = string }
function Permissions.GetPlayerInfo(src)
    local info = { job = '', grade = 0, group = '' }

    if Framework.name == 'esx' and Framework.object then
        local xPlayer = Framework.object.GetPlayerFromId(src)
        if xPlayer then
            info.job = xPlayer.job and xPlayer.job.name or ''
            info.grade = xPlayer.job and xPlayer.job.grade or 0
            info.group = xPlayer.getGroup and xPlayer.getGroup() or ''
        end
    elseif Framework.name == 'qb' and Framework.object then
        local player = Framework.object.Functions.GetPlayer(src)
        if player then
            info.job = player.PlayerData.job and player.PlayerData.job.name or ''
            info.grade = player.PlayerData.job and player.PlayerData.job.grade
                and player.PlayerData.job.grade.level or 0
            info.group = player.PlayerData.group or ''
        end
    elseif Framework.name == 'qbox' then
        local player = exports.qbx_core:GetPlayer(src)
        if player then
            info.job = player.PlayerData.job and player.PlayerData.job.name or ''
            info.grade = player.PlayerData.job and player.PlayerData.job.grade
                and player.PlayerData.job.grade.level or 0
            info.group = player.PlayerData.group or ''
        end
    end

    return info
end

function Permissions.CanEdit(src)
    if Config.Access.openToEveryone then return true end
    if src == 0 then return true end

    if Config.Access.aceEnabled and IsPlayerAceAllowed(src, Config.Access.acePermission) then
        return true
    end

    if Config.Access.identifiersEnabled then
        local wanted = {}
        for _, id in ipairs(Config.Access.identifiers) do wanted[id:lower()] = true end
        for i = 0, GetNumPlayerIdentifiers(src) - 1 do
            if wanted[GetPlayerIdentifier(src, i):lower()] then return true end
        end
    end

    local info = Permissions.GetPlayerInfo(src)

    if Config.Access.groupsEnabled and info.group ~= '' then
        for _, group in ipairs(Config.Access.groups) do
            if group:lower() == info.group:lower() then return true end
        end
    end

    if Config.Access.jobsEnabled and info.job ~= '' then
        local minGrade = Config.Access.jobs[info.job]
        if minGrade and info.grade >= minGrade then return true end
    end

    return false
end

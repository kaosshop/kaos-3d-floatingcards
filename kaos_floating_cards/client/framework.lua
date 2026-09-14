-- Reads the local player's job / group from whichever framework is running.
-- Everything degrades to empty strings on standalone servers.

Framework = { name = 'standalone', object = nil, job = '', grade = 0, group = '' }

local function detect()
    if Config.Framework ~= 'auto' then return Config.Framework end
    if GetResourceState('qbx_core') == 'started' then return 'qbox' end
    if GetResourceState('qb-core') == 'started' then return 'qb' end
    if GetResourceState('es_extended') == 'started' then return 'esx' end
    return 'standalone'
end

local function pull()
    if Framework.name == 'esx' and Framework.object then
        local data = Framework.object.GetPlayerData()
        if data and data.job then
            Framework.job = data.job.name or ''
            Framework.grade = data.job.grade or 0
        end
    elseif (Framework.name == 'qb' or Framework.name == 'qbox') and Framework.object then
        local data = Framework.object.Functions.GetPlayerData()
        if data and data.job then
            Framework.job = data.job.name or ''
            Framework.grade = data.job.grade and data.job.grade.level or 0
            Framework.group = data.group or ''
        end
    end
end

CreateThread(function()
    Framework.name = detect()

    if Framework.name == 'esx' then
        Framework.object = exports['es_extended']:getSharedObject()
    elseif Framework.name == 'qb' then
        Framework.object = exports['qb-core']:GetCoreObject()
    elseif Framework.name == 'qbox' then
        Framework.object = exports['qb-core'] and exports['qb-core']:GetCoreObject() or nil
    end

    Wait(1500)
    pull()
end)

RegisterNetEvent('esx:setJob', function(job)
    Framework.job = job and job.name or ''
    Framework.grade = job and job.grade or 0
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    Framework.job = job and job.name or ''
    Framework.grade = job and job.grade and job.grade.level or 0
end)

RegisterNetEvent('qbx_core:client:onJobUpdate', function(job)
    Framework.job = job and job.name or ''
    Framework.grade = job and job.grade and job.grade.level or 0
end)

--- The server is the source of truth; this is only used for local rule checks.
function Framework.Info()
    return Framework.job, Framework.grade, Framework.group
end

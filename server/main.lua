local QBCore = exports['qb-core']:GetCoreObject()

local CopCount = 0
local isActive = false
local isHacked1 = false
local isExploded = false
local isHacked2 = false
local isHacked3 = false
local isLooted1 = false
local isLooted2 = false

--------------------------------------------- EVENTS --------------------------------------------------

RegisterNetEvent('nxte-carrier:server:OnPlayerLoad', function(amount)
    TriggerEvent('nxte-carrier:server:SetActive')
    TriggerEvent('nxte-carrier:server:SetHack1')
    TriggerEvent('nxte-carrier:server:SetExploded')
    TriggerEvent('nxte-carrier:server:SetHack2')
    TriggerEvent('nxte-carrier:server:SetHack3')
    TriggerEvent('nxte-carrier:server:SetLoot1')
    TriggerEvent('nxte-carrier:server:SetLoot2')
end)

RegisterNetEvent('nxte-carrier:server:ResetMission', function(amount)
    TriggerEvent('nxte-carrier:server:SetActive',false)
    TriggerEvent('nxte-carrier:server:SetHack1', false)
    TriggerEvent('nxte-carrier:server:SetExploded', false)
    TriggerEvent('nxte-carrier:server:SetHack2', false)
    TriggerEvent('nxte-carrier:server:SetHack3', false)
    TriggerEvent('nxte-carrier:server:SetLoot1', false)
    TriggerEvent('nxte-carrier:server:SetLoot2', false)
end)


-- remove money
RegisterNetEvent('nxte-carrier:server:removemoney', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney('cash', tonumber(amount))
end)


RegisterNetEvent('nxte-carrier:server:SetCops', function()
	local amount = 0
    for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    CopCount = amount
    TriggerClientEvent('nxte-carrier:client:SetCops', -1, amount)
end)


RegisterNetEvent('nxte-carrier:server:SetActive', function(status)
    if status ~= nil then
        isActive = status
        TriggerClientEvent('nxte-carrier:client:SetActive',-1, isActive)
    else
        TriggerClientEvent('nxte-carrier:client:SetActive',-1, isActive)
    end
end)


RegisterNetEvent('nxte-carrier:server:SetHack1', function(status)
    if status ~= nil then
        isHacked1 = status
        TriggerClientEvent('nxte-carrier:client:SetHack1',-1, isHacked1)
    else
        TriggerClientEvent('nxte-carrier:client:SetHack1',-1, isHacked1)
    end
end)


RegisterNetEvent('nxte-carrier:server:SetExploded', function(status)
    if status ~= nil then
        isExploded = status
        TriggerClientEvent('nxte-carrier:client:SetExploded',-1, isExploded)
    else
        TriggerClientEvent('nxte-carrier:client:SetExploded',-1, isExploded)
    end
end)


RegisterNetEvent('nxte-carrier:server:SetHack2', function(status)
    if status ~= nil then
        isHacked2 = status
        TriggerClientEvent('nxte-carrier:client:SetHack2',-1, isHacked2)
    else
        TriggerClientEvent('nxte-carrier:client:SetHack2',-1, isHacked2)
    end
end)


RegisterNetEvent('nxte-carrier:server:SetHack3', function(status)
    if status ~= nil then
        isHacked3 = status
        TriggerClientEvent('nxte-carrier:client:SetHack3',-1, isHacked3)
    else
        TriggerClientEvent('nxte-carrier:client:SetHack3',-1, isHacked3)
    end
end)


RegisterNetEvent('nxte-carrier:server:SetLoot1', function(status)
    if status ~= nil then
        isLooted1 = status
        TriggerClientEvent('nxte-carrier:client:SetLoot1',-1, isLooted1)
    else
        TriggerClientEvent('nxte-carrier:client:SetLoot1',-1, isLooted1)
    end
end)


RegisterNetEvent('nxte-carrier:server:SetLoot2', function(status)
    if status ~= nil then
        isLooted2 = status
        TriggerClientEvent('nxte-carrier:client:SetLoot2',-1, isLooted2)
    else
        TriggerClientEvent('nxte-carrier:client:SetLoot2',-1, isLooted2)
    end
end)

---------------------------------- NPC --------------------------------------------------
local peds = { 
    `csb_ramp_marine`,
    `s_m_y_blackops_02`,
    `s_m_y_blackops_03`,
    `s_m_y_armymech_01`,
    `s_m_y_blackops_01`,
}

local getRandomNPC = function()
    return peds[math.random(#peds)]
end

QBCore.Functions.CreateCallback('nxte-carrier:server:SpawnNPC', function(source, cb, loc)
    local netIds = {}
    local netId
    local npc
    for i=1, #Config.Shooters['soldiers'].locations[loc].peds, 1 do
        npc = CreatePed(30, getRandomNPC(), Config.Shooters['soldiers'].locations[loc].peds[i], true, false)
        while not DoesEntityExist(npc) do Wait(10) end
        netId = NetworkGetNetworkIdFromEntity(npc)
        netIds[#netIds+1] = netId
    end
    cb(netIds)
end)


RegisterNetEvent('nx-carrier:server:RemoveItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item,amount)
end)
RegisterNetEvent('nx-carrier:server:AddItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item,amount)
end)
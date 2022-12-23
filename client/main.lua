local QBCore = exports['qb-core']:GetCoreObject()

local heistBlip = nil
local CopCount = 0
local isActive = false
local Buyer = false
local isHacked1 = false
local isExploded = false
local isHacked2 = false
local isHacked3 = false
local isLooted1 = false
local isLooted2 = false

---------------------------------------------------- BLIP ------------------------------------------------------ 
local function HeistBlip()
    heistBlip = AddBlipForCoord(3051.97, -4679.99, 23.02)
    SetBlipSprite(heistBlip, 84)
    SetBlipColour(heistBlip, 66)
    SetBlipDisplay(heistBlip, 4)
    SetBlipScale(heistBlip, 0.8)
    SetBlipAsShortRange(heistBlip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Carrier Heist')
    EndTextCommandSetBlipName(heistBlip)
    SetBlipRoute(heistBlip, true)
end

-------------------------------------------------- ANIM FUNCTIONS ---------------------------------------------------
local function OnHack1Done(success)
    if success then 
        if Config.PedsOnHack1 then
            TriggerEvent('nxte-carrier:client:SpawnNPC',1)
        end
        TriggerServerEvent('nxte-carrier:server:SetHack1', true)
        QBCore.Functions.Notify('Successfully disabled the alarm system!', 'success')
        QBCore.Functions.Notify('Go place the bomb next to the airplane in the 2nd hanger!', 'success')
        TriggerServerEvent('nx-carrier:server:RemoveItem', Config.Hack1Item, 1)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Hack1Item], 'remove')
    else
        QBCore.Functions.Notify('You failed to hack the alarm system!', 'error')
        TriggerServerEvent('nx-carrier:server:RemoveItem', Config.Hack1Item, 1)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Hack1Item], 'remove')
    end
end

local PlantBomb = function()
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do Wait(50) end
    local ped = PlayerPedId()
    local pos = vector4(3056.26, -4661.32, 6.2, 138.04) 
    SetEntityHeading(ped, pos.w)
    Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(`hei_p_m_bag_var22_arm_s`, pos.x, pos.y, pos.z,  true,  true, false)
    SetEntityCollision(bag, false, true)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local charge = CreateObject(`ch_prop_ch_explosive_01a`, x, y, z + 0.2,  true,  true, true)
    SetEntityCollision(charge, false, true)
    AttachEntityToEntity(charge, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Wait(5000)
    DetachEntity(charge, 1, 1)
    FreezeEntityPosition(charge, true)
    DeleteObject(bag)
    NetworkStopSynchronisedScene(bagscene)
    QBCore.Functions.Notify('The bomb will go off in '..Config.BombTime.. ' seconds', 'success')
    Wait(Config.BombTime * 1000)
    DeleteEntity(charge)  
    AddExplosion(3056.26, -4661.32, 7.0, 50, 5.0, true, false, 15.0)
    QBCore.Functions.Notify('You Blew up the missiles!', 'success')
    TriggerServerEvent('nxte-carrier:server:SetExploded', true)
    QBCore.Functions.Notify('Go to the tower to disable the carrier weapons system!', 'success')
    TriggerServerEvent('nx-carrier:server:RemoveItem', Config.BombItem, 1)
    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.BombItem], 'remove')
end

local function OnHack3Done(success)
    if success then 
        if Config.PedsOnHack3 then
            TriggerEvent('nxte-carrier:client:SpawnNPC',3)
        end
        TriggerServerEvent('nxte-carrier:server:SetHack3', true)
        QBCore.Functions.Notify('Successfully disabled the lock system!', 'success')
        QBCore.Functions.Notify('Go loot the crates in the hangers!', 'success')
        TriggerServerEvent('nx-carrier:server:RemoveItem', Config.Hack3Item, 1)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Hack3Item], 'remove')
    else
        QBCore.Functions.Notify('You failed to hack the lock system!', 'error')
        TriggerServerEvent('nx-carrier:server:RemoveItem', Config.Hack3Item, 1)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Hack3Item], 'remove')
    end
end

-------------------------------------------------- EVENTS ------------------------------------------------------
-- sync all info on player Load to prevent exploiting 
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('nxte-carrier:server:OnPlayerLoad')
end)

RegisterNetEvent('nxte-carrier:client:startheist', function()
    TriggerServerEvent('nxte-carrier:server:SetCops')
    TriggerServerEvent('nxte-carrier:server:SetActive')
    local Player = QBCore.Functions.GetPlayerData()
    local cash = Player.money.cash
    local ped = PlayerPedId()
    SetEntityCoords(ped, vector3(1240.03, -3179.68,  6.2))
    SetEntityHeading(ped, 178.36)
    TriggerEvent('animations:client:EmoteCommandStart', {"knock"})
    QBCore.Functions.Progressbar("knock", "Knocking on door...", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        if not isActive then 
            if CopCount >= Config.MinCop then
                if cash >= Config.JobPrice then
                    Buyer = Player.citizenid
                    TriggerServerEvent('nxte-carrier:server:SetActive', true)
                    TriggerServerEvent('nxte-carrier:server:removemoney', Config.JobPrice)
                    QBCore.Functions.Notify("You paid $" ..Config.JobPrice.. ' for the GPS location!', "success")
                    HeistBlip()
                else
                    QBCore.Functions.Notify("Am i working with an amature here ? Ofcourse i want it in cash", "error")
                end
            else
                QBCore.Functions.Notify("There is not enough police", "error")
            end
        else
            QBCore.Functions.Notify("No one is answering the door", "error")
        end
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify("Cancelled Knocking on the door", "error")
    end)
end)

RegisterNetEvent('nxte-carrier:client:hack1', function()
    TriggerServerEvent('nxte-carrier:server:SetActive')
    TriggerServerEvent('nxte-carrier:server:SetHack1')
    TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"})
    QBCore.Functions.Progressbar("knock", "Preparing for hack", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        if isActive then
            if not isHacked1 then
                if QBCore.Functions.HasItem(Config.Hack1Item) then
                    TriggerEvent('nxte-carrier:anim:hack1')
                else
                    QBCore.Functions.Notify('You do not have the right tools to do this', 'error')
                end
            else
                QBCore.Functions.Notify('The Alarm has already been disabled', 'error')
            end
        else
            QBCore.Functions.Notify("You can not do this right now", "error")
        end
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify("Cancelled Preparing the hack", "error")
    end)
end)

RegisterNetEvent('nxte-carrier:client:bomb', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"})
    QBCore.Functions.Progressbar("knock", "Preparing Bomb", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        if isActive then
            if isHacked1 then
                if not isExploded then 
                    if QBCore.Functions.HasItem(Config.BombItem) then
                        PlantBomb()
                    else
                        QBCore.Functions.Notify('You do not have the right tools to do this', 'error')
                    end
                else
                    QBCore.Functions.Notify('The Bomb has already been placed', 'error')
                end
            else
                QBCore.Functions.Notify('The Alarm is still active', 'error')
            end
        else
            QBCore.Functions.Notify("You can not do this right now", "error")
        end
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify("Cancelled Preparing the bomb", "error")
    end)
end)

RegisterNetEvent('nxte-carrier:client:hack2', function()
    TriggerServerEvent('nxte-carrier:server:SetActive')
    TriggerEvent('animations:client:EmoteCommandStart', {"type"})
    QBCore.Functions.Progressbar("knock", "Preparing for hack", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        if isActive then 
            if isExploded then
                if not isHacked2 then
                    if QBCore.Functions.HasItem(Config.Hack2Item) then
                        exports['hacking']:OpenHackingGame(Config.Hack2Time, Config.Hack2Squares, Config.Hack2Repeat, function(success)
                            if success then 
                                if Config.PedsOnHack2 then
                                    TriggerEvent('nxte-carrier:client:SpawnNPC',2)
                                end
                                TriggerServerEvent('nxte-carrier:server:SetHack2', true)
                                QBCore.Functions.Notify('Successfully disabled weapon system!', 'success')
                                QBCore.Functions.Notify('Go to the other tower to disable the security locks!', 'success')
                                TriggerServerEvent('nx-carrier:server:RemoveItem', Config.Hack2Item, 1)
                                TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Hack2Item], 'remove')
                            else
                                QBCore.Functions.Notify('You failed to hack the weapon system!', 'error')
                                TriggerServerEvent('nx-carrier:server:RemoveItem', Config.Hack2Item, 1)
                                TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Hack2Item], 'remove')
                            end
                        end)
                    else
                        QBCore.Functions.Notify('You do not have the right tools to do this', 'error')
                    end
                else
                    QBCore.Functions.Notify('The weapons system has already been disabled', 'error')
                end
            else 
                QBCore.Functions.Notify('The Bomb has not exploded yet!','error')
            end
        else
            QBCore.Functions.Notify("you can not do this right now", "error")
        end
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify("Cancelled Preparing the hack", "error")
    end)
end)

RegisterNetEvent('nxte-carrier:client:hack3', function()
    TriggerServerEvent('nxte-carrier:server:SetActive')
    TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"})
    QBCore.Functions.Progressbar("knock", "Preparing for hack", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        if isActive then
            if isHacked2 then
                if not isHacked3 then
                    if QBCore.Functions.HasItem(Config.Hack3Item) then
                        TriggerEvent('nxte-carrier:anim:hack3')
                    else
                        QBCore.Functions.Notify('You do not have the right tools to do this', 'error')
                    end
                else
                    QBCore.Functions.Notify('The locks have already been disabled', 'error')
                end
            else
                QBCore.Functions.Notify('The Weapon system is still active', 'error')
            end
        else
            QBCore.Functions.Notify("You can not do this right now", "error")
        end
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify("Cancelled Preparing the hack", "error")
    end)
end)


RegisterNetEvent('nxte-carrier:client:loot1', function()
    TriggerServerEvent('nxte-carrier:server:SetActive')
    TriggerEvent('animations:client:EmoteCommandStart', {"medic"})
    QBCore.Functions.Progressbar("knock", "Searching Crate...", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        if isActive then
            if isHacked3 then
                if not isLooted1 then 
                    TriggerServerEvent('nxte-carrier:server:SetLoot1', true)
                    local amountA = math.random(Config.Loot1MinAmountA,Config.Loot1MaxAmountA)
                    local amountB = math.random(Config.Loot1MinAmountB,Config.Loot1MaxAmountB)
                    TriggerServerEvent('nx-carrier:server:AddItem', Config.Loot1ItemA, amountA)
                    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Loot1ItemA], 'add', amountA)
                    TriggerServerEvent('nx-carrier:server:AddItem', Config.Loot1ItemB, amountB)
                    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Loot1ItemB], 'add', amountB)
                else 
                    QBCore.Functions.Notify('This crate is empty!', 'error')
                end
            else
                QBCore.Functions.Notify('The Lock system is still active', 'error')
            end
        else
            QBCore.Functions.Notify("You can not do this right now", "error")
        end
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify("Cancelled Searching Crate", "error")
    end)
end)

RegisterNetEvent('nxte-carrier:client:loot2', function()
    TriggerServerEvent('nxte-carrier:server:SetActive')
    TriggerEvent('animations:client:EmoteCommandStart', {"medic"})
    QBCore.Functions.Progressbar("knock", "Searching Crate...", 4000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        if isActive then
            if isHacked3 then
                if not isLooted2 then 
                    TriggerServerEvent('nxte-carrier:server:SetLoot2', true)
                    local amountA = math.random(Config.Loot2MinAmountA,Config.Loot2MaxAmountA)
                    local amountB = math.random(Config.Loot2MinAmountB,Config.Loot2MaxAmountB)
                    TriggerServerEvent('nx-carrier:server:AddItem', Config.Loot2ItemA, amountA)
                    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Loot2ItemA], 'add', amountA)
                    TriggerServerEvent('nx-carrier:server:AddItem', Config.Loot2ItemB, amountB)
                    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Loot2ItemB], 'add', amountB)
                else 
                    QBCore.Functions.Notify('This crate is empty!', 'error')
                end
            else
                QBCore.Functions.Notify('The Lock system is still active', 'error')
            end
        else
            QBCore.Functions.Notify("You can not do this right now", "error")
        end
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify("Cancelled Searching Crate", "error")
    end)
end)


------------------------------------------------- ANIMATIONS EVENTS --------------------------------------------------

RegisterNetEvent('nxte-carrier:anim:hack1', function()
    local loc = {x,y,z,h}
    loc.x = 3105.34
    loc.y = -4811.65
    loc.z = 7.03
    loc.h = 286.03

    local animDict = 'anim@heists@ornate_bank@hack'
    RequestAnimDict(animDict)
    RequestModel('hei_prop_hst_laptop')
    RequestModel('hei_p_m_bag_var22_arm_s')

    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded('hei_prop_hst_laptop')
        or not HasModelLoaded('hei_p_m_bag_var22_arm_s') do
        Wait(100)
    end

    local ped = PlayerPedId()
    SetEntityCoords(ped, vector3(3105.34, -4811.65,  7.03))
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
    SetPedComponentVariation(ped, 5, Config.HideBagID, 1, 1)
    SetEntityHeading(ped, loc.h)
    local animPos = GetAnimInitialOffsetPosition(animDict, 'hack_enter', loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos2 = GetAnimInitialOffsetPosition(animDict, 'hack_loop', loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, 'hack_exit', loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)

    FreezeEntityPosition(ped, true)
    local netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), targetPosition, 1, 1, 0)
    local laptop = CreateObject(GetHashKey('hei_prop_hst_laptop'), targetPosition, 1, 1, 0)

    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, 'hack_enter', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, 'hack_enter_bag', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, 'hack_enter_laptop', 4.0, -8.0, 1)

    local netScene2 = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, 'hack_loop', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, 'hack_loop_bag', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, 'hack_loop_laptop', 4.0, -8.0, 1)

    local netScene3 = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, 'hack_exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, 'hack_exit_bag', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene3, animDict, 'hack_exit_laptop', 4.0, -8.0, 1)

    Wait(200)
    NetworkStartSynchronisedScene(netScene)
    Wait(6300)
    NetworkStartSynchronisedScene(netScene2)
    Wait(2000)

    exports['hacking']:OpenHackingGame(Config.Hack1Time, Config.Hack1Squares, Config.Hack1Repeat, function(success)
        NetworkStartSynchronisedScene(netScene3)
        NetworkStopSynchronisedScene(netScene3)
        DeleteObject(bag)
        SetPedComponentVariation(ped, 5, Config.BagUseID, 0, 1)
        DeleteObject(laptop)
        FreezeEntityPosition(ped, false)
        OnHack1Done(success)
    end)
end)

RegisterNetEvent('nxte-carrier:anim:hack3', function()
    local loc = {x,y,z,h}
    loc.x = 3090.06
    loc.y = -4723.94 
    loc.z = 27.0
    loc.h = 113.1

    local animDict = 'anim@heists@ornate_bank@hack'
    RequestAnimDict(animDict)
    RequestModel('hei_prop_hst_laptop')
    RequestModel('hei_p_m_bag_var22_arm_s')

    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded('hei_prop_hst_laptop')
        or not HasModelLoaded('hei_p_m_bag_var22_arm_s') do
        Wait(100)
    end

    local ped = PlayerPedId()
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
    SetPedComponentVariation(ped, 5, Config.HideBagID, 1, 1)
    SetEntityHeading(ped, loc.h)
    local animPos = GetAnimInitialOffsetPosition(animDict, 'hack_enter', loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos2 = GetAnimInitialOffsetPosition(animDict, 'hack_loop', loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, 'hack_exit', loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)

    FreezeEntityPosition(ped, true)
    local netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), targetPosition, 1, 1, 0)
    local laptop = CreateObject(GetHashKey('hei_prop_hst_laptop'), targetPosition, 1, 1, 0)

    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, 'hack_enter', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, 'hack_enter_bag', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, 'hack_enter_laptop', 4.0, -8.0, 1)

    local netScene2 = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, 'hack_loop', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, 'hack_loop_bag', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, 'hack_loop_laptop', 4.0, -8.0, 1)

    local netScene3 = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, 'hack_exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, 'hack_exit_bag', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, netScene3, animDict, 'hack_exit_laptop', 4.0, -8.0, 1)

    Wait(200)
    NetworkStartSynchronisedScene(netScene)
    Wait(6300)
    NetworkStartSynchronisedScene(netScene2)
    Wait(2000)

    exports['hacking']:OpenHackingGame(Config.Hack3Time, Config.Hack3Squares, Config.Hack3Repeat, function(success)
        NetworkStartSynchronisedScene(netScene3)
        NetworkStopSynchronisedScene(netScene3)
        DeleteObject(bag)
        SetPedComponentVariation(ped, 5, Config.BagUseID, 0, 1)
        DeleteObject(laptop)
        FreezeEntityPosition(ped, false)
        OnHack3Done(success)
    end)
end)


------------------------------------------------- NPC'S --------------------------------------------------------
-----------
--- NPC ---
-----------
-- set NPC data
RegisterNetEvent('nxte-carrier:client:SpawnNPC', function(position)
    QBCore.Functions.TriggerCallback('nxte-carrier:server:SpawnNPC', function(netIds, position)
        Wait(1000)
        local ped = PlayerPedId()
        for i=1, #netIds, 1 do
            local npc = NetworkGetEntityFromNetworkId(netIds[i])
            SetPedDropsWeaponsWhenDead(npc, false)
            GiveWeaponToPed(npc, Config.PedGun, 250, false, true)
            SetPedMaxHealth(npc, 300)
            SetPedArmour(npc, 200)
            SetCanAttackFriendly(npc, true, false)
            TaskCombatPed(npc, ped, 0, 16)
            SetPedCombatAttributes(npc, 46, true)
            SetPedCombatAttributes(npc, 0, false)
            SetPedCombatAbility(npc, 100)
            SetPedAsCop(npc, true)
            SetPedRelationshipGroupHash(npc, `HATES_PLAYER`)
            SetPedAccuracy(npc, 60)
            SetPedFleeAttributes(npc, 0, 0)
            SetPedKeepTask(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
        end
    end, position)
end)


----------------------------------------------- SERVER SYNC EVENTS ---------------------------------------------

RegisterNetEvent('nxte-carrier:client:SetCops', function(amount)
    CopCount = amount
end)

RegisterNetEvent('nxte-carrier:client:SetActive', function(status)
    isActive = status
end)

RegisterNetEvent('nxte-carrier:client:SetHack1', function(status)
    isHacked1 = status
end)

RegisterNetEvent('nxte-carrier:client:SetExploded', function(status)
    isExploded = status
end)

RegisterNetEvent('nxte-carrier:client:SetHack2', function(status)
    isHacked2 = status
end)

RegisterNetEvent('nxte-carrier:client:SetHack3', function(status)
    isHacked3 = status
end)

RegisterNetEvent('nxte-carrier:client:SetLoot1', function(status)
    isLooted1 = status
end)

RegisterNetEvent('nxte-carrier:client:SetLoot2', function(status)
    isLooted2 = status
end)

-- reset heist after start
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isActive then
            Citizen.Wait(Config.JobStartTimer*60000)
            RemoveBlip(heistBlip)
            TriggerServerEvent('nxte-mrpd:server:ResetMission')
        end
    end
end)


-- reset heist after success
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLooted1 and isLooted2 then
            RemoveBlip(heistBlip)
            Citizen.Wait(Config.JobFinishTimer*60000)
            TriggerServerEvent('nxte-carrier:server:ResetMission')
        end
    end
end)

-- reset heist on player death
Citizen.CreateThread(function()
    while true do
        if isActive then
            local Player = QBCore.Functions.GetPlayerData()
            local Playerid = Player.citizenid
            if Playerid == Buyer then
                if Player.metadata["inlaststand"] or Player.metadata["isdead"] then
                    QBCore.Functions.Notify('Mission Failed', 'error')
                    TriggerServerEvent('nxte-carrier:server:ResetMission')
                    Citizen.Wait(2000)
                    Buyer = nil
                end
            end
        end
        Citizen.Wait(5000)
    end
end)

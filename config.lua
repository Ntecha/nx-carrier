Config = {}

Config.JobPrice = 25000 -- price to start the job
Config.JobStartTimer = 90 -- how long after activating the heist does it reset in minuits
Config.JobFinishTimer = 30 -- how long after finishing the mission the heist resets
Config.MinCop = 1 -- min amount of on-duty cops needed to be able to start the heist


-- Hack 1 
Config.Hack1Item = 'electronickit' -- item needed for hack 1
Config.Hack1Time = 20 -- time player has to do the hack
Config.Hack1Squares = 2 -- amount of squares player has to hack 
Config.Hack1Repeat = 1 -- how many times player has to complete the hack to finish it

-- Bomb
Config.BombItem = 'thermite' -- item needed to place bomb
Config.BombTime = 30 -- amount of seconds the bomb needs to detonate after placing it 

-- Hack 2
Config.Hack2Item = 'trojan_usb' -- item needed for hack 2
Config.Hack2Time = 20 -- time player has to do the hack 
Config.Hack2Squares = 2 -- amount of squares player has to hack 
Config.Hack2Repeat = 1 -- how many times player has to complete the hack to finish it

-- Hack 3
Config.Hack3Item = 'trojan_usb' -- item needed for hack 2
Config.Hack3Time = 20 -- time player has to do the hack 
Config.Hack3Squares = 2 -- amount of squares player has to hack 
Config.Hack3Repeat = 1 -- how many times player has to complete the hack to finish it



-- loot 1 
-- Item 1
Config.Loot1ItemA = 'weapon_compactrifle'
Config.Loot1MinAmountA = 1
Config.Loot1MaxAmountA = 5
-- Item 2
Config.Loot1ItemB = 'rifle_ammo'
Config.Loot1MinAmountB = 1
Config.Loot1MaxAmountB = 20

-- loot 2
-- item 1 
Config.Loot2ItemA = 'weapon_smg'
Config.Loot2MinAmountA = 1
Config.Loot2MaxAmountA = 5
-- item 2
Config.Loot2ItemB = 'smg_ammo'
Config.Loot2MinAmountB = 1
Config.Loot2MaxAmountB = 20


-- Peds
Config.PedsOnHack1 = true
Config.PedsOnHack2 = true
Config.PedsOnHack3 = true


Config.PedGun = 'weapon_assaultrifle' -- weapon NPC's use

-- NPC coords
Config.Shooters = {
    ['soldiers'] = {
        locations = {
            [1] = { -- on hack 1
                peds = {vector3(3034.57, -4679.34, 6.08),vector3(3035.44, -4681.7, 6.08),vector3(3038.43, -4686.94, 6.08),vector3(3044.05, -4688.04, 6.08),vector3(3061.17, -4681.13, 6.08),vector3(3071.21, -4693.21, 6.08),vector3(3069.31, -4701.83, 6.08),vector3(3073.89, -4721.34, 6.08),vector3(3073.89, -4721.34, 6.08),vector3(3083.07, -4752.87, 6.08),vector3(3085.92, -4741.96, 10.74),vector3(3085.85, -4741.84, 10.74)}
            },
            [2] = { -- on hack 2
            peds = {vector3(3067.43, -4703.15, 15.26),vector3(3063.22, -4712.57, 15.26),vector3(3066.74, -4725.21, 15.26),vector3(3079.61, -4735.5, 15.26),vector3(3060.07, -4743.99, 15.26),vector3(3053.04, -4733.87, 15.26),vector3(3046.67, -4713.41, 15.26),vector3(3069.01, -4707.68, 15.26),vector3(3084.8, -4702.62, 15.26),vector3(3088.08, -4713.72, 15.26),vector3(3091.68, -4718.28, 15.26)}
            },
            [3] = { -- on hack 3
            peds = {vector3(3034.57, -4679.34, 6.08),vector3(3035.44, -4681.7, 6.08),vector3(3038.43, -4686.94, 6.08),vector3(3044.05, -4688.04, 6.08),vector3(3061.17, -4681.13, 6.08),vector3(3071.21, -4693.21, 6.08),vector3(3069.31, -4701.83, 6.08),vector3(3073.89, -4721.34, 6.08),vector3(3073.89, -4721.34, 6.08),vector3(3083.07, -4752.87, 6.08),vector3(3085.92, -4741.96, 10.74),vector3(3085.85, -4741.84, 10.74),vector3(3067.43, -4703.15, 15.26),vector3(3063.22, -4712.57, 15.26),vector3(3066.74, -4725.21, 15.26),vector3(3079.61, -4735.5, 15.26),vector3(3060.07, -4743.99, 15.26),vector3(3053.04, -4733.87, 15.26),vector3(3046.67, -4713.41, 15.26),vector3(3069.01, -4707.68, 15.26),vector3(3084.8, -4702.62, 15.26),vector3(3088.08, -4713.72, 15.26),vector3(3091.68, -4718.28, 15.26)}
            },
        },
    }
}
local QBCore = exports['qb-core']:GetCoreObject()

-- start heist
exports['qb-target']:AddBoxZone("nxte-carrier:startheist", vector3(1240.08, -3180.24, 8.18), 1, 1.4, {
	name = "nxte-carrier:startheist",
	heading = 358.5,
	debugPoly = false,
	minZ = 6.2,
	maxZ = 8.6,
}, {
	options = {
		{
            type = "client",
            event = "nxte-carrier:client:startheist",
			icon = "fas fa-circle",
			label = "Start Heist",
		},
	},
	distance = 2.5
})


-- hack 1
exports['qb-target']:AddBoxZone("nxte-carrier:hack1", vector3(3106.21, -4811.47, 8.5), 0.7, 0.7, {
	name = "nxte-carrier:hack1",
	heading = 103.89,
	debugPoly = false,
	minZ = 6.9,
	maxZ = 7.9,
}, {
	options = {
		{
            type = "client",
            event = "nxte-carrier:client:hack1",
			icon = "fas fa-circle",
			label = "Hack Alarm System",
		},
	},
	distance = 2.5
})



-- place Bomb 1
exports['qb-target']:AddBoxZone("nxte-carrier:bomb", vector3(3056.22, -4661.76, 6.75), 2.7, 0.9, {
	name = "nxte-carrier:bomb",
	heading = 45.19,
	debugPoly = false,
	minZ = 5.4,
	maxZ = 6.1,
}, {
	options = {
		{
            type = "client",
            event = "nxte-carrier:client:bomb",
			icon = "fas fa-circle",
			label = "Place Bomb",
		},
	},
	distance = 2.5
})


-- Hack 2
exports['qb-target']:AddBoxZone("nxte-carrier:hack2", vector3(3086.35, -4687.92, 28.24), 0.5, 0.6, {
	name = "nxte-carrier:hack2",
	heading = 105.42,
	debugPoly = false,
	minZ = 26.9,
	maxZ = 27.2,
}, {
	options = {
		{
            type = "client",
            event = "nxte-carrier:client:hack2",
			icon = "fas fa-circle",
			label = "Hack Terminal",
		},
	},
	distance = 2.5
})



-- Hack 3
exports['qb-target']:AddBoxZone("nxte-carrier:hack3", vector3(3089.51, -4723.59, 27.57), 0.5, 0.5, {
	name = "nxte-carrier:hack3",
	heading = 105.42,
	debugPoly = false,
	minZ = 26,
	maxZ = 26.9,
}, {
	options = {
		{
            type = "client",
            event = "nxte-carrier:client:hack3",
			icon = "fas fa-circle",
			label = "Hack Computer",
		},
	},
	distance = 2.5
})


-- loot 1
exports['qb-target']:AddBoxZone("nxte-carrier:loot1", vector3(3083.62, -4749.41, 7.37), 1, 1.5, {
	name = "nxte-carrier:loot1",
	heading = 189.11,
	debugPoly = false,
	minZ = 5.6,
	maxZ = 6.3,
}, {
	options = {
		{
            type = "client",
            event = "nxte-carrier:client:loot1",
			icon = "fas fa-circle",
			label = "Search Crate",
		},
	},
	distance = 2.5
})

-- loot 2
exports['qb-target']:AddBoxZone("nxte-carrier:loot2", vector3(3066.31, -4678.87, 6.66), 0.8, 1.4, {
	name = "nxte-carrier:loot2",
	heading = 116.79,
	debugPoly = false,
	minZ = 5,
	maxZ = 5.8,
}, {
	options = {
		{
            type = "client",
            event = "nxte-carrier:client:loot2",
			icon = "fas fa-circle",
			label = "Search Crate",
		},
	},
	distance = 2.5
})
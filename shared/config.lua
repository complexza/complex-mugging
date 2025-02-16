return {
    debugMode = false,
    requiredRobbingTime = 10,      -- In Seconds
    allowedSilentTime = 5,         -- In Seconds
    cooldownTime = 15 * 60 * 1000, -- In Minutes
    maxRobbingDistance = 5.0,
    policeCallSettings = {
        enabled = true,
        chanceAtDay = 70,
        chanceAtNight = 30
    },
    maxItemsPerRobbery = math.random(1, 3),
    itemsTable = {
        { item = 'stolenlaptop',        amount = 1,                    chance = "extremelyCommon" },
        { item = 'money',               amount = math.random(50, 250), chance = "extremelyCommon" },
        { item = 'lighter',             amount = 1,                    chance = "extremelyCommon" },
        { item = 'perfume',             amount = 1,                    chance = "extremelyCommon" },
        { item = 'golfclubs',           amount = 1,                    chance = "extremelyCommon" },
        { item = 'twogoldchain',        amount = math.random(1, 1),    chance = "veryCommon" },
        { item = 'securityphone',       amount = math.random(1, 1),    chance = "veryCommon" },
        { item = 'eightgoldchain',      amount = math.random(1, 1),    chance = "veryCommon" },
        { item = 'pistol_ammo',         amount = math.random(10, 25),  chance = "common" },
        { item = 'water_bottle',        amount = math.random(1, 3),    chance = "common" },
        { item = 'rolling_paper',       amount = math.random(1, 5),    chance = "common" },
        { item = 'fivegoldchain',       amount = math.random(1, 1),    chance = "common" },
        { item = 'tengoldchain',        amount = math.random(1, 1),    chance = "common" },
        { item = 'acousticguitar',      amount = math.random(1, 1),    chance = "uncommon" },
        { item = 'bd_vpn',              amount = 1,                    chance = "rare" },
        { item = 'laundromatkeys',      amount = 1,                    chance = "veryRare" },
        { item = 'bitcoin',             amount = 1,                    chance = "veryRare" },
        { item = 'weapon_combatpistol', amount = 1,                    chance = "veryRare" },
    },
    chancesTable = {
        extremelyCommon = {
            min = 81,
            max = 100
        },
        veryCommon = {
            min = 61,
            max = 80
        },
        common = {
            min = 41,
            max = 60
        },
        uncommon = {
            min = 21,
            max = 40
        },
        rare = {
            min = 11,
            max = 20
        },
        veryRare = {
            min = 1,
            max = 10
        }
    },
    blacklistedWeapons = {
        `WEAPON_ACIDPACKAGE`,
        `WEAPON_UNARMED`,
    },
}

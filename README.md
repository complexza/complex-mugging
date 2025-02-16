# Complex Mugging

## Setup Instructions

### Prerequisites
Ensure you have the following installed:
- **QBox Framework** (Can be easily converted to work with any other framework)
- **OXLib**

### Installation Steps
1. **Download & Extract**
   - Place the `complex-mugging` folder inside your FiveM `resources` directory.

2. **Add to Server Config**
   - Open your `server.cfg` file and add:
     ```ini
     ensure ox_lib
     ensure complex-mugging
     ```

3. **Configure the Script**
   - Modify `shared/config.lua` to match your server preferences (see Configuration Guide below).

4. **Restart Server**
   - Restart your FiveM server and check the console for errors.
   - Ensure the script is running with `refresh` and `start complex-mugging` commands.

## Configuration Guide

### Editing `shared/config.lua`
The `config.lua` file contains various settings you can modify to customize the script.

#### General Settings
```lua
debugMode = false -- Enable debug mode for logging
requiredRobbingTime = 10 -- Time required to rob (seconds)
allowedSilentTime = 5 -- Time before another robbery can happen (seconds)
cooldownTime = 15 * 60 * 1000 -- Cooldown time before robbing again (milliseconds)
maxRobbingDistance = 5.0 -- Maximum distance from the target to successfully rob
```

#### Police Call Settings
```lua
policeCallSettings = {
    enabled = true, -- Enable or disable police alerts
    chanceAtDay = 70, -- Chance of police being alerted during the day
    chanceAtNight = 30 -- Chance of police being alerted at night
}
```

#### Item Rewards
The script allows configurable items that can be obtained from a robbery.
```lua
maxItemsPerRobbery = math.random(1, 3) -- Maximum items received per robbery
itemsTable = {
    { item = 'stolenlaptop', amount = 1, chance = "extremelyCommon" },
    { item = 'money', amount = math.random(50, 250), chance = "extremelyCommon" },
    { item = 'lighter', amount = 1, chance = "extremelyCommon" },
    { item = 'bitcoin', amount = 1, chance = "veryRare" },
    { item = 'weapon_combatpistol', amount = 1, chance = "veryRare" }
}
```

#### Item Rarity Chances
```lua
chancesTable = {
    extremelyCommon = { min = 81, max = 100 },
    veryCommon = { min = 61, max = 80 },
    common = { min = 41, max = 60 },
    uncommon = { min = 21, max = 40 },
    rare = { min = 11, max = 20 },
    veryRare = { min = 1, max = 10 }
}
```

#### Blacklisted Weapons
The following weapons cannot be used for mugging:
```lua
blacklistedWeapons = {
    `WEAPON_ACIDPACKAGE`,
    `WEAPON_UNARMED`
}
```

## Support
I will not provide support on this script as its no longer maintained.

local sharedConfig = require 'shared.config'

local function generateChance()
    return math.random(0, 100)
end

local function getChanceRange(chanceCategory)
    return sharedConfig.chancesTable[chanceCategory]
end

local function selectRandomItems()
    local selectedItems = {}
    local randomChance = generateChance()
    Debug('Chance Generated: ' .. randomChance)
    for i = 1, #sharedConfig.itemsTable do
        local chanceRange = getChanceRange(sharedConfig.itemsTable[i].chance)
        -- Check if the generated chance falls within the item's chance range
        if randomChance >= chanceRange.min and randomChance <= chanceRange.max then
            Debug('Items Selected: ' ..
            sharedConfig.itemsTable[i].chance ..
            ' ' .. sharedConfig.itemsTable[i].item .. ' ' .. sharedConfig.itemsTable[i].amount)
            selectedItems[#selectedItems + 1] = { name = sharedConfig.itemsTable[i].item, amount = sharedConfig
            .itemsTable[i].amount }
        end
    end
    return selectedItems
end

lib.callback.register('complex-npc:server:giveRewards', function(source)
    local selectedRewards = selectRandomItems()
    local maxRewards = sharedConfig.maxItemsPerRobbery
    Debug('Max Rewards', maxRewards)
    for i = 1, #selectedRewards do
        local item = selectedRewards[i]
        if maxRewards > 0 then
            if not exports.ox_inventory:CanCarryItem(source, item.name, item.amount) then
                exports.qbx_core:Notify(source, 'You\'re pockets are full', 'error')
                return false
            end

            local success = exports.ox_inventory:AddItem(source, item.name, item.amount)
            if not success then
                return false
            end
            maxRewards = maxRewards - 1
            Debug('Items Given: ' .. item.name .. ' Amount: ' .. item.amount)
            Debug('Rewards Left: ' .. maxRewards)
        end
    end
    return true
end)

-- server.lua
-- This script must run on the server side

local QBCore = exports['qb-core']:GetCoreObject()

-- Loop through each item defined in the config file
for usedItemName, itemData in pairs(Config.UsableItems) do
    QBCore.Functions.CreateUseableItem(usedItemName, function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        
        -- Check if the player exists before proceeding
        if not Player then return end
        
        -- Get the item names and counts from the config table
        local itemToRemove = itemData.itemToRemove
        local countToRemove = itemData.countToRemove or 1
        local itemToGive = itemData.itemToGive
        local countToGive = itemData.countToGive or 1
        
        -- Remove the specified item(s) from the player's inventory using the unique citizen ID
        -- We check that the player has enough of the item to remove first.
        if Player.Functions.GetItemByName(itemToRemove) and Player.Functions.GetItemByName(itemToRemove).amount >= countToRemove then
            exports.ox_inventory:RemoveItem(Player.PlayerData.citizenid, itemToRemove, countToRemove)
            
            -- Give the new item
            exports.ox_inventory:AddItem(Player.PlayerData.citizenid, itemToGive, countToGive)
            
            -- Send a notification to the player
            TriggerClientEvent('QBCore:Notify', src, 'You used ' .. countToRemove .. 'x ' .. QBCore.Shared.Items[itemToRemove].label .. ' and received ' .. countToGive .. 'x ' .. QBCore.Shared.Items[itemToGive].label .. '!', 'success')
        else
            -- Handle the case where the player doesn't have the required items
            TriggerClientEvent('QBCore:Notify', src, 'You do not have enough ' .. QBCore.Shared.Items[itemToRemove].label .. ' to use this.', 'error')
        end
    end)
end

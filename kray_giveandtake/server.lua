-- Loop through each item defined in the config file and register it as usable
for usedItemName, itemData in pairs(Config.UsableItems) do
    exports['qbx_core']:CreateUseableItem(usedItemName, function(source, item)
        local src = source
        
        -- Get the item names and counts from the config table
        local itemToRemove = itemData.itemToRemove
        local countToRemove = itemData.countToRemove or 1
        local itemToGive = itemData.itemToGive
        local countToGive = itemData.countToGive or 1
        
        -- Use ox_inventory's exports to check the player's inventory
        local hasItem = exports.ox_inventory:GetItemCount(src, itemToRemove)
        
        if hasItem and hasItem >= countToRemove then
            -- Remove the item on the server side using the ox_inventory export
            local removed = exports.ox_inventory:RemoveItem(src, itemToRemove, countToRemove)
            
            if removed then
                -- Trigger the client event to play the animation
                TriggerClientEvent('kray_giveandtake:client:playAnimation', src, itemData.animDict, itemData.animName)
                
                -- Give the new item
                exports.ox_inventory:AddItem(src, itemToGive, countToGive)
                
                -- Use QBX's notification system
                local giveItemLabel = exports.ox_inventory:Items(itemToGive) and exports.ox_inventory:Items(itemToGive).label or itemToGive
                TriggerClientEvent('QBCore:Notify', src, 'You used ' .. countToRemove .. 'x ' .. item.label .. ' and received ' .. countToGive .. 'x ' .. giveItemLabel .. '!', 'success')
            else
                TriggerClientEvent('QBCore:Notify', src, 'Failed to use the item.', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'You do not have enough ' .. item.label .. ' to use this.', 'error')
        end
    end)
end

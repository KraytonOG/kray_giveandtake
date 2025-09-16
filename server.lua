-- Store exports in local variables for better performance and checks
local QBCore = exports['qbx_core']
local ox_inventory = exports.ox_inventory
local progressbar = exports.progressbar

-- Check for required dependencies at startup
if not QBCore or not ox_inventory or not progressbar then
    print('^1[kray_giveandtake] ERROR: Missing a required dependency. Please ensure qbx_core, ox_inventory, and progressbar are running.^7')
    return
end

-- Register a server event to handle the final result from the client after the progress bar is done
RegisterServerEvent('kray_giveandtake:server:finishUse', function(itemData)
    local src = source
    local itemToRemove = itemData.itemToRemove
    local countToRemove = itemData.countToRemove or 1

    -- Re-validate the item count just before removing it
    if ox_inventory:GetItemCount(src, itemToRemove) >= countToRemove then
        local removed = ox_inventory:RemoveItem(src, itemToRemove, countToRemove)

        if removed then
            -- Give the new items and prepare the notification string
            local receivedItems = {}
            if itemData.itemsToGive then
                for _, itemToGive in ipairs(itemData.itemsToGive) do
                    ox_inventory:AddItem(src, itemToGive.name, itemToGive.count)
                    local giveItemLabel = ox_inventory:Items(itemToGive.name) and ox_inventory:Items(itemToGive.name).label or itemToGive.name
                    table.insert(receivedItems, tostring(itemToGive.count) .. 'x ' .. giveItemLabel)
                end
            end

            local receivedItemsString = table.concat(receivedItems, ', ')
            local message
            if #receivedItemsString > 0 then
                message = 'You received: ' .. receivedItemsString .. '.'
            else
                message = 'You used an item and completed an action.'
            end

            QBCore:Notify(src, message, itemData.notificationSettings and itemData.notificationSettings.type or 'success', nil, itemData.notificationSettings)
        else
            QBCore:Notify(src, 'Failed to remove item. Please try again.', 'error')
        end
    else
        QBCore:Notify(src, 'Action failed: You no longer have the required item. This attempt has been logged.', 'error')
    end
end)

-- Loop through each item and register it as usable
for usedItemName, itemData in pairs(Config.UsableItems) do
    QBCore:CreateUseableItem(usedItemName, function(source, item)
        local src = source
        local itemToRemove = itemData.itemToRemove
        local countToRemove = itemData.countToRemove or 1

        -- Only check for item existence; removal happens after progress bar
        if ox_inventory:GetItemCount(src, itemToRemove) >= countToRemove then
            TriggerClientEvent('kray_giveandtake:client:startProgress', src, itemData)
        else
            QBCore:Notify(src, 'You do not have enough ' .. item.label .. ' to use this.', 'error')
        end
    end)
end

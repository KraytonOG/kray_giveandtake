-- Store exports in local variables for better performance and checks
local QBCore = exports['qbx_core']
local ox_inventory = exports.ox_inventory

-- Check for required dependencies at startup
if not QBCore or not ox_inventory then
    print('^1[kray_giveandtake] ERROR: Missing a required dependency. Please ensure qbx_core and ox_inventory are running.^7')
    return
end

print('^2[kray_giveandtake] Script loaded successfully!^7')
print('^3[kray_giveandtake] Progress bar system: ' .. Config.ProgressBar .. '^7')
print('^3[kray_giveandtake] Notification system: ' .. Config.Notification .. '^7')

-- Notification function based on Config.Notification
local function SendNotification(src, message, notifType, notificationSettings)
    if Config.Notification == 'lation_ui' then
        -- Use Lation UI notifications
        TriggerClientEvent('kray_giveandtake:client:lationNotify', src, {
            title = notificationSettings and notificationSettings.title or nil,
            message = message,
            type = notifType or 'info',
            icon = notificationSettings and notificationSettings.icon or nil,
            iconColor = notificationSettings and notificationSettings.iconColor or nil
        })
    elseif Config.Notification == 'ox_lib' then
        -- Use ox_lib notifications
        TriggerClientEvent('kray_giveandtake:client:oxNotify', src, {
            description = message,
            type = notifType or 'success',
            icon = notificationSettings and notificationSettings.icon or nil
        })
    else
        -- Use QBCore notifications (default)
        QBCore:Notify(src, message, notifType or 'success', nil, notificationSettings)
    end
end

-- Register a server event to handle the final result from the client after the progress bar is done
RegisterServerEvent('kray_giveandtake:server:finishUse', function(itemData)
    local src = source
    local itemToRemove = itemData.itemToRemove
    local countToRemove = itemData.countToRemove or 1

    print('^3[kray_giveandtake] Server finishUse event received from player: ' .. src .. '^7')

    -- Re-validate the item count just before removing it
    if ox_inventory:GetItemCount(src, itemToRemove) >= countToRemove then
        local removed = ox_inventory:RemoveItem(src, itemToRemove, countToRemove)

        if removed then
            print('^2[kray_giveandtake] Successfully removed ' .. countToRemove .. 'x ' .. itemToRemove .. '^7')
            
            -- Give the new items and prepare the notification string
            local receivedItems = {}
            if itemData.itemsToGive then
                for _, itemToGive in ipairs(itemData.itemsToGive) do
                    ox_inventory:AddItem(src, itemToGive.name, itemToGive.count)
                    local giveItemLabel = ox_inventory:Items(itemToGive.name) and ox_inventory:Items(itemToGive.name).label or itemToGive.name
                    table.insert(receivedItems, tostring(itemToGive.count) .. 'x ' .. giveItemLabel)
                    print('^2[kray_giveandtake] Added ' .. itemToGive.count .. 'x ' .. itemToGive.name .. '^7')
                end
            end

            local receivedItemsString = table.concat(receivedItems, ', ')
            local message
            if #receivedItemsString > 0 then
                message = 'You received: ' .. receivedItemsString .. '.'
            else
                message = 'You used an item and completed an action.'
            end

            SendNotification(src, message, 'success', itemData.notificationSettings)
        else
            print('^1[kray_giveandtake] Failed to remove item^7')
            SendNotification(src, 'Failed to remove item. Please try again.', 'error', nil)
        end
    else
        print('^1[kray_giveandtake] Player no longer has required items^7')
        SendNotification(src, 'Action failed: You no longer have the required item. This attempt has been logged.', 'error', nil)
    end
end)

-- Loop through each item and register it as usable
print('^2[kray_giveandtake] Registering usable items...^7')
for usedItemName, itemData in pairs(Config.UsableItems) do
    QBCore:CreateUseableItem(usedItemName, function(source, item)
        local src = source
        print('^2[kray_giveandtake] Item used by player: ' .. src .. ' | Item: ' .. usedItemName .. '^7')
        
        local itemToRemove = itemData.itemToRemove
        local countToRemove = itemData.countToRemove or 1

        -- Only check for item existence; removal happens after progress bar
        local itemCount = ox_inventory:GetItemCount(src, itemToRemove)
        print('^3[kray_giveandtake] Player has ' .. itemCount .. ' of ' .. itemToRemove .. ' (needs ' .. countToRemove .. ')^7')
        
        if itemCount >= countToRemove then
            print('^2[kray_giveandtake] Triggering client progress for player: ' .. src .. '^7')
            -- Add the item label to itemData
            itemData.label = item.label
            TriggerClientEvent('kray_giveandtake:client:startProgress', src, itemData)
        else
            print('^1[kray_giveandtake] Player does not have enough items^7')
            SendNotification(src, 'You do not have enough ' .. item.label .. ' to use this.', 'error', nil)
        end
    end)
end
print('^2[kray_giveandtake] All items registered successfully!^7')

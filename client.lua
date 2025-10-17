local QBCore = exports['qbx_core']

-- Client-side notification handler for Lation UI
RegisterNetEvent('kray_giveandtake:client:lationNotify', function(data)
    print('^5[kray_giveandtake] Lation notify triggered^7')
    print('^5[kray_giveandtake] Data: ' .. json.encode(data) .. '^7')
    
    exports.lation_ui:notify({
        title = data.title,
        message = data.message,
        type = data.type,
        icon = data.icon,
        iconColor = data.iconColor
    })
end)

-- Client-side notification handler for ox_lib
RegisterNetEvent('kray_giveandtake:client:oxNotify', function(data)
    print('^5[kray_giveandtake] ox_lib notify triggered^7')
    print('^5[kray_giveandtake] Data: ' .. json.encode(data) .. '^7')
    
    lib.notify({
        description = data.description,
        type = data.type,
        icon = data.icon
    })
end)

RegisterNetEvent('kray_giveandtake:client:startProgress', function(itemData)
    print('^2=== CLIENT EVENT TRIGGERED ===^7')
    print('^3itemData received: ' .. json.encode(itemData, {indent=true}) .. '^7')
    print('^3Progress bar system: ' .. Config.ProgressBar .. '^7')
    print('^3Notification system: ' .. Config.Notification .. '^7')
    
    CreateThread(function()
        local success = false

        -- Helper function to send client notifications
        local function SendClientNotification(message, notifType, icon)
            if Config.Notification == 'lation_ui' then
                exports.lation_ui:notify({
                    title = notifType == 'error' and 'Error' or notifType == 'success' and 'Success' or 'Info',
                    message = message,
                    type = notifType or 'info',
                    icon = icon or 'fas fa-info-circle'
                })
            elseif Config.Notification == 'ox_lib' then
                lib.notify({
                    description = message,
                    type = notifType or 'info',
                    icon = icon or 'fas fa-info-circle'
                })
            else
                QBCore:Notify(message, notifType or 'info')
            end
        end

        -- Determine which progress bar system to use
        if Config.ProgressBar == 'lation_ui' then
            print('^2Using Lation UI progressbar^7')
            
            -- Check if lation_ui exists
            local lationExists = pcall(function()
                return exports.lation_ui
            end)
            
            if not lationExists then
                print('^1ERROR: lation_ui resource not found or not started^7')
                SendClientNotification('Failed to start progress bar: lation_ui not available.', 'error', 'fas fa-exclamation-triangle')
                return
            end

            -- Build Lation UI progress options
            local lationOptions = {
                label = 'Using ' .. (itemData.label or itemData.itemToRemove or 'item') .. '...',
                duration = 3000,
                canCancel = true,
                useWhileDead = false,
                disable = {
                    move = false,
                    car = false,
                    combat = false,
                }
            }

            -- Add animation if provided
            if itemData.animDict and itemData.animName then
                lationOptions.anim = {
                    dict = itemData.animDict,
                    clip = itemData.animName,
                    flag = itemData.animFlag or 49,
                }
            end

            print('^3Lation UI Progress options: ' .. json.encode(lationOptions, {indent=true}) .. '^7')

            -- Start Lation UI progress bar
            print('^2Starting Lation UI progress bar...^7')
            success = exports.lation_ui:progressBar(lationOptions)

            print('^3Lation UI Progress completed. Success: ' .. tostring(success) .. '^7')

            -- Handle completion
            if success then
                print('^2Progress completed successfully, triggering server event^7')
                TriggerServerEvent('kray_giveandtake:server:finishUse', itemData)
            else
                print('^1Progress was cancelled^7')
                SendClientNotification('Item use cancelled.', 'error', 'fas fa-times')
            end

        else
            -- Use ox_lib progress bar (default)
            print('^2Using ox_lib progressbar^7')
            
            if not lib or not lib.progressBar then
                print('^1ERROR: ox_lib or progressBar not available^7')
                SendClientNotification('Failed to start progress bar: ox_lib not ready.', 'error', 'fas fa-exclamation-triangle')
                return
            end

            -- Build ox_lib progress options
            local progressOptions = {
                duration = 3000,
                label = 'Using ' .. (itemData.label or itemData.itemToRemove or 'item') .. '...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    move = false,
                    car = false,
                    combat = false,
                    mouse = false,
                },
            }

            -- Only add animation if both dict and name are provided
            if itemData.animDict and itemData.animName then
                progressOptions.anim = {
                    dict = itemData.animDict,
                    clip = itemData.animName,
                    flag = itemData.animFlag or 1,
                }
            end

            print('^3ox_lib Progress options: ' .. json.encode(progressOptions, {indent=true}) .. '^7')

            -- Start ox_lib progress bar
            print('^2Starting ox_lib progress bar...^7')
            success = lib.progressBar(progressOptions)

            print('^3ox_lib Progress completed. Success: ' .. tostring(success) .. '^7')

            -- Handle completion
            if success then
                print('^2Progress completed successfully, triggering server event^7')
                TriggerServerEvent('kray_giveandtake:server:finishUse', itemData)
            else
                print('^1Progress was cancelled^7')
                SendClientNotification('Item use cancelled.', 'error', 'fas fa-times')
            end
        end
    end)
end)

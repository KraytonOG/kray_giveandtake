local QBCore = exports['qbx_core']

RegisterNetEvent('kray_giveandtake:client:startProgress', function(itemData)
    CreateThread(function()
        -- IMPORTANT: Check if progressbar is available
        if not exports['progressbar'] then
            print('ERROR: progressbar resource is not available. Ensure it is started before kray_giveandtake.')
            QBCore:Notify('Failed to start progress bar: progressbar not ready.', 'error')
            return -- Exit the thread if progressbar is not ready
        end

        local progressOptions = {
            name = 'use_item_progress_' .. GetGameTimer(),
            label = 'Using ' .. (itemData.label or itemData.itemToRemove or 'item') .. '...',
            duration = 3000,
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = itemData.animDict,
                anim = itemData.animName,
                flags = itemData.animFlag or 1,
            },
            prop = {},
            propTwo = {},
        }

        exports['progressbar']:Progress(progressOptions, function(cancelled)
            if not cancelled then
               -- print('Debug: Progress bar completed. Firing server event to finish use.')
                TriggerServerEvent('kray_giveandtake:server:finishUse', itemData)
            else
              -- print('Debug: Progress bar was cancelled or failed.')
                QBCore:Notify('Item use cancelled.', 'error')
            end
        end)
    end)
end)

-- client.lua

local QBCore = exports['qbx_core']
-- Remove the ox_lib export line

-- Register the event to start the progress bar and animation
RegisterNetEvent('kray_giveandtake:client:startProgress', function(itemData)
    CreateThread(function()
        -- IMPORTANT: Check if qb-progressbar is available
        if not exports['progressbar'] then
            print('ERROR: qb-progressbar resource is not available. Ensure it is started before kray_giveandtake.')
            QBCore:Notify('Failed to start progress bar: qb-progressbar not ready.', 'error')
            return -- Exit the thread if qb-progressbar is not ready
        end

        -- Define the progress bar options for qb-progressbar
        local progressOptions = {
            name = 'use_item_progress_' .. GetGameTimer(), -- Unique name for the progress bar
            label = 'Using ' .. (itemData.itemToRemove or 'item') .. '...',
            duration = 3000, -- Duration in milliseconds
            useWhileDead = false,
            canCancel = true,
            controlDisables = { -- qb-progressbar uses 'controlDisables'
                disableMovement = true, -- Changed from 'movement' in ox_lib
                disableCarMovement = true, -- Added for comprehensive disabling
                disableMouse = false,
                disableCombat = true, -- Changed from 'combat' in ox_lib
            },
            animation = { -- qb-progressbar uses 'animation' table directly
                animDict = itemData.animDict,
                anim = itemData.animName, -- Changed from 'clip' in ox_lib
                flags = itemData.animFlag or 1,
            },
            prop = {}, -- Add empty tables for prop if not used, to prevent nil errors
            propTwo = {},
        }

        -- Show the progress bar and handle the outcome in the callback function
        -- Calling qb-progressbar export
        exports['progressbar']:Progress(progressOptions, function(cancelled)
            if not cancelled then
                -- The progress bar finished without being cancelled.
                print('Debug: Progress bar completed. Firing server event to finish use.')
                TriggerServerEvent('kray_giveandtake:server:finishUse', itemData)
            else
                -- The progress bar was cancelled.
                print('Debug: Progress bar was cancelled or failed.')
                QBCore:Notify('Item use cancelled.', 'error')
            end
        end)
    end)
end)

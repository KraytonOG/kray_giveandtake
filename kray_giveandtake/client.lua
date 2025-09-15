RegisterNetEvent('kray_giveandtake:client:playAnimation', function(animDict, animName)
    local playerPed = PlayerPedId()
    
    -- Request the animation dictionary
    RequestAnimDict(animDict)
    
    local timeout = 5000 -- 5 second timeout in milliseconds
    local startTime = GetGameTimer()

    -- Wait for the dictionary to load with a timeout
    while not HasAnimDictLoaded(animDict) and (GetGameTimer() - startTime < timeout) do
        Wait(0)
    end

    if HasAnimDictLoaded(animDict) then
        print('Debug: Animation dictionary loaded successfully: ' .. animDict)
        
        -- Clear any existing tasks on the ped to prevent conflicts.
        ClearPedTasksImmediately(playerPed)

        -- Play the animation with a high-priority flag (49 = looping, upper body, secondary slot).
        -- Parameters: ped, animDict, animName, blendIn, blendOut, duration, flag, playbackRate, lockX, lockY, lockZ
        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)
        
        print('Debug: Attempting to play animation: ' .. animName)

        -- Wait for 3 seconds before stopping the animation
        Citizen.Wait(3000)

        -- Clear the ped's tasks, which stops the animation
        ClearPedTasksImmediately(playerPed)
        
    else
        print('Error: Failed to load animation dictionary: ' .. animDict)
    end
end)

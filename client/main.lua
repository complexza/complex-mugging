local sharedConfig = require 'shared.config'
local weaponLoop, busyRobbing, allowedRob, isOnCoolDown = false, false, false, false
local timeRobbing = 0

local function generateChance()
    return math.random(0, 100)
end

local function attemptPoliceCall()
    if not sharedConfig.policeCallSettings.enabled then
        Debug('Police Calls Disabled')
        return
    end

    local hours = GetClockHours()
    local currentChance = sharedConfig.policeCallSettings.chanceAtDay
    Debug('Current Clock Hours: ', hours)
    if hours >= 1 and hours <= 6 then
        currentChance = sharedConfig.policeCallSettings.chanceAtNight
    end

    local generatedChance = generateChance()
    Debug('Police Call Chance:', currentChance, 'Generated Chance:', generatedChance)
    if currentChance <= generatedChance then
        Debug('Police have been Called')
        exports["ps-dispatch"]:CustomAlert({
            coords = GetEntityCoords(cache.ped),
            dispatchCode = "10-34",
            message = "Possible Mugging",
            description = 'An anonymous caller has reported a possible mugging in progress.',
            radius = 0,
            sprite = 225,
            color = 1,
            scale = 1.0,
            length = 3,
        })
    end
end

lib.onCache('weapon', function(newWeapon)
    if not LocalPlayer.state.isLoggedIn then return end
    if not newWeapon then
        weaponLoop = false
        allowedRob = false
        return
    end
    Debug('Is Player On Mugging Cooldown', isOnCoolDown)
    if not weaponLoop and not isOnCoolDown then
        weaponLoop = true
        CreateThread(function()
            while weaponLoop do
                if not sharedConfig.blacklistedWeapons[newWeapon] then
                    if isOnCoolDown then
                        Debug('Player On Mugging Cooldown')
                        return
                    end
                    if IsPedAPlayer(cache.ped) and not busyRobbing then
                        local foundEntity, entityFound = GetEntityPlayerIsFreeAimingAt(cache.playerId)
                        local targettedNPC = entityFound
                        Debug('Targeted NPC', targettedNPC)
                        if foundEntity and IsPedHuman(entityFound) and not IsPedAPlayer(entityFound) then
                            if not IsPedInAnyVehicle(entityFound, false) and #(GetEntityCoords(cache.ped) - (GetEntityCoords(targettedNPC))) <= sharedConfig.maxRobbingDistance then
                                Debug('Is Ped NPC: ', IsPedHuman(entityFound), 'Is Ped Player: ',
                                    IsPedAPlayer(entityFound))
                                allowedRob = true
                                timeRobbing = 0
                                busyRobbing = true
                                CreateThread(function()
                                    while allowedRob do
                                        if NetworkIsPlayerTalking(cache.playerId) then
                                            timeRobbing = timeRobbing + 1
                                            Debug('Time Busy Robbing', timeRobbing)
                                        end
                                        Wait(1000)
                                        if not NetworkIsPlayerTalking(cache.playerId) then
                                            Debug('Player was not talking, Checking Silent Time')
                                            local silentTime = 0
                                            while silentTime < sharedConfig.allowedSilentTime and not NetworkIsPlayerTalking(cache.playerId) do
                                                silentTime = silentTime + 1
                                                Debug('Silent Time ', silentTime)
                                                Wait(1000)
                                            end
                                            if silentTime >= sharedConfig.allowedSilentTime then
                                                allowedRob = false
                                                Debug('Player was not talking for too long, Cancelling Robbery')
                                                TaskSmartFleePed(targettedNPC, cache.ped, 100.0, -1, false, false)
                                                busyRobbing = false
                                            end
                                        end
                                    end
                                end)
                            else
                                Debug('Ped is not suitable for robbery (too far or in vehicle)')
                            end
                        end
                        while allowedRob do
                            SetBlockingOfNonTemporaryEvents(targettedNPC, true)
                            SetPedFleeAttributes(targettedNPC, 0, false)
                            SetPedCombatAttributes(targettedNPC, 17, true)
                            SetPedCombatAttributes(targettedNPC, 46, true)
                            TaskHandsUp(targettedNPC, -1, cache.ped, -1, true)
                            PlayAmbientSpeech1(targettedNPC, 'Generic_Shocked_High', 'Speech_Params_Force')
                            if timeRobbing >= sharedConfig.requiredRobbingTime then
                                attemptPoliceCall()
                                local givenItems = lib.callback.await('complex-npc:server:giveRewards', false)
                                if givenItems then
                                    PlayAmbientSpeech1(targettedNPC, 'Generic_Fuck_You', 'Speech_Params_Force')
                                    TaskPlayAnim(targettedNPC, "mp_common", "givetake1_a", 8.0, -8.0, -1, 1, 0, false,
                                        false, false)
                                    Wait(500)
                                    allowedRob = false
                                    busyRobbing = false
                                    isOnCoolDown = true
                                    ClearPedTasks(targettedNPC)
                                    TaskSmartFleePed(targettedNPC, cache.ped, 100.0, -1, false, false)
                                    SetTimeout(sharedConfig.cooldownTime, function()
                                        isOnCoolDown = false
                                    end)
                                end
                            end
                            Wait(1000)
                        end
                        Wait(50)
                    end
                    Wait(50)
                end
            end
        end)
    end
end)

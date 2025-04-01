local storedOriginalPos = nil
local inPCCheck = false

-- Input-Blocking
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if inPCCheck then
            for i = 0, 255 do
                if i ~= 1 and i ~= 2 and i ~= 245 then
                    DisableControlAction(0, i, true)
                end
            end
        end
    end
end)

-- Teleport and freeze
RegisterNetEvent("myScript:teleportAndFreeze")
AddEventHandler("myScript:teleportAndFreeze", function(coords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
    FreezeEntityPosition(playerPed, true)
    print(string.format("Teleported and frozen at: %.2f, %.2f, %.2f", coords.x, coords.y, coords.z))
end)

-- Return Player to old Position (Type command again.)
RegisterNetEvent("myScript:returnPlayer")
AddEventHandler("myScript:returnPlayer", function()
    local playerPed = PlayerPedId()
    if storedOriginalPos then
         SetEntityCoords(playerPed, storedOriginalPos.x, storedOriginalPos.y, storedOriginalPos.z, false, false, false, true)
         FreezeEntityPosition(playerPed, false)
         storedOriginalPos = nil
         inPCCheck = false
         SetNuiFocus(false, false)
         SendNUIMessage({ action = 'close' })
         print("Returned to original position.")
    else
         print("No stored position available.")
    end
end)

RegisterNetEvent("myScript:pcCheck")
AddEventHandler("myScript:pcCheck", function(coords)
    local playerPed = PlayerPedId()
    if not storedOriginalPos then
         storedOriginalPos = GetEntityCoords(playerPed)
         print(string.format("Stored original position: %.2f, %.2f, %.2f", storedOriginalPos.x, storedOriginalPos.y, storedOriginalPos.z))
    end
    inPCCheck = true
    TriggerEvent("myScript:teleportAndFreeze", coords)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'open' })
    print("Opened NUI overlay (action: 'open').")
end)

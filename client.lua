-- client.lua

local storedOriginalPos = nil
local inPCCheck = false

-- Input-Blocking: Disable nearly all controls while in PC-Check,
-- but allow camera movement (controls 1 & 2) and chat (control 245).
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

-- Teleport and Freeze: Moves the player to the specified coordinates and freezes them.
RegisterNetEvent("myScript:teleportAndFreeze")
AddEventHandler("myScript:teleportAndFreeze", function(coords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
    FreezeEntityPosition(playerPed, true)
    print(string.format("Teleported and frozen at: %.2f, %.2f, %.2f", coords.x, coords.y, coords.z))
end)

-- Return Player: Moves the player back to their stored position, unfreezes them, and closes the overlay.
RegisterNetEvent("myScript:returnPlayer")
AddEventHandler("myScript:returnPlayer", function()
    local playerPed = PlayerPedId()
    if storedOriginalPos then
         SetEntityCoords(playerPed, storedOriginalPos.x, storedOriginalPos.y, storedOriginalPos.z, false, false, false, true)
         FreezeEntityPosition(playerPed, false)
         storedOriginalPos = nil
         inPCCheck = false
         -- Remove NUI focus and send a message to close the overlay.
         SetNuiFocus(false, false)
         SendNUIMessage({ action = 'close' })
         print("Returned to original position.")
    else
         print("No stored position available.")
    end
end)

-- PC-Check: Saves the player's current position, teleports/freeze them, and opens the HTML overlay.
RegisterNetEvent("myScript:pcCheck")
AddEventHandler("myScript:pcCheck", function(coords)
    local playerPed = PlayerPedId()
    if not storedOriginalPos then
         storedOriginalPos = GetEntityCoords(playerPed)
         print(string.format("Stored original position: %.2f, %.2f, %.2f", storedOriginalPos.x, storedOriginalPos.y, storedOriginalPos.z))
    end
    inPCCheck = true
    TriggerEvent("myScript:teleportAndFreeze", coords)
    -- Open the NUI overlay (HTML overlay will be displayed via index.html)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'open' })
    print("Opened NUI overlay (action: 'open').")
end)

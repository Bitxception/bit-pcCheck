local OVERLAY_ALPHA_START = 180
local TEXT_ALPHA_START = 255
local OVERLAY_DISPLAY_TIME = 5000
local FADE_STEP = 3
local FADE_INTERVAL = 50

local isFadingOut = false
local isRedScreenActive = false
local redScreenAlpha = OVERLAY_ALPHA_START
local textAlpha = TEXT_ALPHA_START
local storedOriginalPos = nil
local inPCCheck = false

local function drawOverlay()
    DrawRect(0.5, 0.5, 1.0, 1.0, 255, 0, 0, redScreenAlpha)
    SetTextFont(4)
    SetTextScale(1.2, 1.2)
    SetTextColour(255, 255, 255, textAlpha)
    SetTextCentre(true)
    SetTextDropshadow(2, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString("Du wurdest zum PC-Check eingeladen.")
    DrawText(0.5, 0.43)
end

-- Unlock
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if inPCCheck then
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)   -- Look LeftRight
            EnableControlAction(0, 2, true)   -- Look Down
            EnableControlAction(0, 245, true) -- Chat "T"
        end
    end
end)

RegisterNetEvent("myScript:teleportAndFreeze")
AddEventHandler("myScript:teleportAndFreeze", function(coords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
    FreezeEntityPosition(playerPed, true)
    print(string.format("teleportAndFreeze ausgeführt: %.2f, %.2f, %.2f", coords.x, coords.y, coords.z))
end)

RegisterNetEvent("myScript:showPcCheckOverlay")
AddEventHandler("myScript:showPcCheckOverlay", function()
    if isRedScreenActive then return end
    isRedScreenActive = true
    redScreenAlpha = OVERLAY_ALPHA_START
    textAlpha = TEXT_ALPHA_START

    Citizen.CreateThread(function()
        while isRedScreenActive do
            drawOverlay()
            Citizen.Wait(0)
        end
    end)

    Citizen.Wait(OVERLAY_DISPLAY_TIME)
    TriggerEvent("myScript:fadeOutOverlayAndText")
end)

RegisterNetEvent("myScript:fadeOutOverlayAndText")
AddEventHandler("myScript:fadeOutOverlayAndText", function()
    if isFadingOut then return end
    isFadingOut = true

    Citizen.CreateThread(function()
        while redScreenAlpha > 0 or textAlpha > 0 do
            if redScreenAlpha > 0 then redScreenAlpha = redScreenAlpha - FADE_STEP end
            if textAlpha > 0 then textAlpha = textAlpha - FADE_STEP end
            if redScreenAlpha <= 0 and textAlpha <= 0 then
                isRedScreenActive = false
                break
            end
            Citizen.Wait(FADE_INTERVAL)
        end
        isFadingOut = false
        print("Overlay ausgeblendet.")
    end)
end)

RegisterNetEvent("myScript:returnPlayer")
AddEventHandler("myScript:returnPlayer", function()
    local playerPed = PlayerPedId()
    if storedOriginalPos then
         SetEntityCoords(playerPed, storedOriginalPos.x, storedOriginalPos.y, storedOriginalPos.z, false, false, false, true)
         FreezeEntityPosition(playerPed, false)
         print(string.format("Player zurück teleportiert zu: %.2f, %.2f, %.2f", storedOriginalPos.x, storedOriginalPos.y, storedOriginalPos.z))
         storedOriginalPos = nil
         inPCCheck = false
    else
         print("Keine gespeicherte Position vorhanden.")
    end
end)

RegisterNetEvent("myScript:pcCheck")
AddEventHandler("myScript:pcCheck", function(coords)
    local playerPed = PlayerPedId()
    if not storedOriginalPos then
         storedOriginalPos = GetEntityCoords(playerPed)
         print(string.format("Originalposition gespeichert: %.2f, %.2f, %.2f", storedOriginalPos.x, storedOriginalPos.y, storedOriginalPos.z))
    end
    inPCCheck = true
    TriggerEvent("myScript:teleportAndFreeze", coords)
    TriggerEvent("myScript:showPcCheckOverlay")
end)
